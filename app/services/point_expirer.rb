class PointExpirer

  # Calculate expired loyalty points on the specified date
  # and create PointLineItems for each user with calculated points.
  # Returns array of PointLineItem objects with expired points.
  #
  # ==== Example
  # expired_points = PointExpirer.expire(Date.parse("13/03/2013"))
  def self.expire(date)

    # This query return only non zero rows
    expired_points = Arel::Table.new(:expired_points)
    query = expired_points.from(expired_points_table(date))
                  .project(expired_points[:points].as('points'), expired_points[:user_id].as('user_id'))
                  .where(expired_points[:points].lt(0))

    expired_points_attributes = PointLineItem.connection.exec_query(query.to_sql)

    # Create PointLineItem for each user who has expired points
    ActiveRecord::Base.transaction do
      expired_points_attributes.map do |attributes|
        PointLineItem.create(attributes.merge(created_at: date, source: 'Points expired'))
      end
    end
  end

  private

  # Prepare subquery to calculate delta between total points and awarded points
  def self.expired_points_table(date)
    total = total_table(date)
    awarded = awarded_table(date)

    # Avoid NULL points in query
    total_points = Arel::Nodes::NamedFunction.new('COALESCE',[total[:points],0]).to_sql
    awarded_points = Arel::Nodes::NamedFunction.new('COALESCE',[awarded[:points],0]).to_sql

    points = PointLineItem.arel_table
    points.join(total, Arel::Nodes::OuterJoin).on(points[:user_id].eq(total[:user_id]))
          .join(awarded, Arel::Nodes::OuterJoin).on(points[:user_id].eq(awarded[:user_id]))
          .project("- #{total_points} - #{awarded_points} AS points", points[:user_id])
          .group(points[:user_id]).as('expired_points')
  end

  # Prepare subquery to calculate total points on the specified date
  def self.total_table(date)
    PointLineItem.select(PointLineItem.arel_table[:points].sum.as("points"), :user_id)
                 .where('created_at <=?', date)
                 .group(:user_id)
                 .as('total')
  end

  # Prepare subquery to calculate only awarded points on the specified date
  def self.awarded_table(date)
    PointLineItem.select(PointLineItem.arel_table[:points].sum.as("points"), :user_id)
                 .where(created_at: date.prev_year..date)
                 .where('points > 0')
                 .group(:user_id)
                 .as('awarded')
  end
end
