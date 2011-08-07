namespace :generate do
  desc "Create output for h3rald.com integration"
  task :h3rald => [:web5] do
    dir = Glyph::PROJECT/'output/h3rald'
    (dir/"glyph/book").mkpath
    # Copy files in subdir
    (dir).find do |i|
      if i.file? then
        next if i.to_s.match(Regexp.escape(dir/'glyph')) 
        dest = dir/"ruby-compendium/book/#{i.relative_path_from(Glyph::PROJECT/dir)}"
        src = i.to_s
        Pathname.new(dest).parent.mkpath
        file_copy src, dest
      end
    end
    # Remove files from output dir
    dir.children.each do |c|
      unless c == dir/'ruby-compendium' then
        c.directory? ? c.rmtree : c.unlink
      end
    end
    (dir/'ruby-compendium/book/images/').rmtree
    # Create project page
		project = Glyph.filter %{layout/project[
				@contents[#{file_load(Glyph::PROJECT/'text/notes.glyph')}]
			]}
		file_write dir/"ruby-compendium.textile", project

  end	
end
