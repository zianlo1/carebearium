if Rails.env.development?
  require_relative 'task_helpers'

  namespace :preprocess do
    task :jumps do
      jump_map = {}

      read_seed_file('solar_systems.json').each do |row|
        jump_map[row[:id]] = { from: row[:id], security: row[:security] }
      end

      read_seed_file('jumps_raw.json').each do |row|
        next unless jump_map[row[:from]]

        jump_map[row[:from]][:jumps] = row[:to].split(',').map(&:to_i).sort
      end

      # ----- Hisec islands -----

      seen            = Set.new []
      continous_hisec = Set.new []
      visit_next      = Set.new [30000142]

      while visit_next.any?
        visit_now = visit_next.to_a
        visit_next.clear
        visit_now.each do |current|
          seen.add current

          data = jump_map[current]

          next unless data[:security] >= 0.5

          continous_hisec.add current

          data[:jumps].each do |nxt|
            unless seen.include?(nxt)
              visit_next.add nxt
              seen.add nxt
            end
          end
        end
      end

      jump_map.each do |id, data|
        next unless data[:security] >= 0.5

        jump_map[id][:hisec_island] = !continous_hisec.include?(id)
      end

      # ----- Hisec islands -----

      # ----- Distances -----

      visit = -> (id, system, depth) do
        case system[:security]
        when 0.5..1
          unless system[:hisec_island]
            jump_map[id][:continous_hisec] ||= depth
          end
          jump_map[id][:nearest_hisec] ||= depth
        when 0.1..0.4
          jump_map[id][:lowsec] ||= depth
        else
          jump_map[id][:nullsec] ||= depth
        end
      end

      jump_map.each do |id, data|
        seen       = Set.new []
        visit_next = Set.new [id]
        depth      = 0

        while visit_next.any? && [:continous_hisec, :nearest_hisec, :lowsec, :nullsec].any?{ |key| jump_map[id][key].blank? }
          visit_now = visit_next.to_a
          visit_next.clear
          visit_now.each do |current|
            seen.add current

            curent_data = jump_map[current]

            visit.call(id, curent_data, depth)

            curent_data[:jumps].each do |nxt|
              unless seen.include?(nxt)
                visit_next.add nxt
                seen.add nxt
              end
            end
          end
          depth += 1
        end
      end

      # ----- Distances -----

      jump_map.each do |id, _|
        jump_map[id].delete(:security)
        jump_map[id].delete(:hisec_island)
      end

      write_seed_file 'jumps.json', jump_map.values
    end
  end

  desc "Preprocess data dump"
  task preprocess: %w(jumps).map{ |t| "preprocess:#{t}" }
end
