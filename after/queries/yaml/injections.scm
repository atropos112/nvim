; extends


(block_mapping_pair 
  key: (flow_node 
	(plain_scalar
	  (string_scalar))) 
  value: (block_node 
	(block_scalar 
	  (comment) @cmt (#eq? @cmt "# yaml")  
	  ) @injection.content 
	 (#offset! @injection.content 0 1 0 -1)
	 (#set! injection.language "yaml")
)) 


(block_mapping_pair 
  key: (flow_node 
	(plain_scalar
	  (string_scalar))) 
  value: (block_node 
	(block_scalar 
	  (comment) @cmt (#eq? @cmt "# toml")  
	  ) @injection.content 
	 (#offset! @injection.content 0 1 0 -1)
	 (#set! injection.language "toml")
)) 

(block_mapping_pair 
  key: (flow_node 
	(plain_scalar
	  (string_scalar))) 
  value: (block_node 
	(block_scalar 
	  (comment) @cmt (#eq? @cmt "# sh")  
	  ) @injection.content 
	 (#offset! @injection.content 0 1 0 -1)
	 (#set! injection.language "bash")
)) 

(block_mapping_pair 
  key: (flow_node 
	(plain_scalar
	  (string_scalar))) 
  value: (block_node 
	(block_scalar 
	  (comment) @cmt (#eq? @cmt "# bash")  
	  ) @injection.content 
	 (#offset! @injection.content 0 1 0 -1)
	 (#set! injection.language "bash")
)) 
