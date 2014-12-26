class FilesystemController < ApiController
  @@fs_root = File.realpath(PortlandConfig[:fs_root])

  def path
    resolved_path = File.realpath(File.join(@@fs_root, params[:path].to_s))
    raise 'Invalid path' unless resolved_path.starts_with?(@@fs_root)
    name = resolved_path == @@fs_root ? '/' : File.basename(resolved_path)

    if File.directory?(resolved_path)
      children = Dir.entries(resolved_path).select {|e| e != '.' && e != '..'}.map do |e|
        child_path = File.join(resolved_path, e)
        {type: File.directory?(child_path) ? 'directory' : 'file', name: File.basename(child_path), path: fs_root_rel_path(child_path)}
      end
      respond_with({type: 'directory', name: name, path: fs_root_rel_path(resolved_path), expanded: true, children: children})
    else
      respond_with({type: 'file', name: name, path: fs_root_rel_path(resolved_path)})
    end
  end

  private
  def fs_root_rel_path(path)
    result = path[@@fs_root.length..-1]
    result = "/#{result}" unless result.starts_with?('/')
    return result
  end
end
