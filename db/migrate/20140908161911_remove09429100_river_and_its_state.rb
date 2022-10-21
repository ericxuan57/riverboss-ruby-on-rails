class Remove09429100RiverAndItsState < ActiveRecord::Migration
  def change
    r = River.find_by_site_no('09429100')
    r.destroy! if r.present?
    s = State.find_by_name('American Samoa')
    s.destroy! if s.present?
  end
end
