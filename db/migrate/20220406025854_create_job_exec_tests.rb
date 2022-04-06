class CreateJobExecTests < ActiveRecord::Migration[6.1]
  def change
    create_table :job_exec_tests do |t|
      t.string :job_name

      t.timestamps
    end
  end
end
