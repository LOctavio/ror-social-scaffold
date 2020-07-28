class AddFriendshipTriggerAndFunction < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
        CREATE OR REPLACE FUNCTION create_friendship()
          RETURNS trigger
          LANGUAGE 'plpgsql' AS 
		      $BODY$
          BEGIN
            INSERT INTO friendships (user_id, friend_id, status, created_at, updated_at)
              VALUES (new.friend_id, new.user_id, true, current_timestamp, current_timestamp);
            RETURN NEW;
          END;
          $BODY$;
        
		CREATE TRIGGER trg_update_friendship
            AFTER UPDATE OF status ON friendships
            FOR EACH ROW
			WHEN (OLD.status = false AND NEW.status = true)
            EXECUTE PROCEDURE create_friendship();
        SQL
      end
      
	  dir.down do
        execute <<-SQL
          DROP TRIGGER trg_update_friendship IF EXISTS ON friendships;
          DROP FUNCTION create_friendship();
        SQL
      end
    end
  end
end
