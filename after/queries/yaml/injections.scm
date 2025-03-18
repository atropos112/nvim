; extends

;yaml

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
(comment) @cmt (#eq? @cmt "# yaml")  
value: (block_node 
  (block_mapping
	(block_mapping_pair 
	  key: (flow_node 
		(plain_scalar
		  (string_scalar))) 
	  value: (block_node 
		(block_scalar) @injection.content
		(#offset! @injection.content 0 1 0 -1)
		(#set! injection.language "yaml")
))))) 


;json

(block_mapping_pair 
key: (flow_node 
  (plain_scalar 
	(string_scalar))) 
(comment) @cmt (#eq? @cmt "# json")  
value: (block_node 
  (block_mapping
	(block_mapping_pair 
	  key: (flow_node 
		(plain_scalar
		  (string_scalar))) 
	  value: (block_node 
		(block_scalar) @injection.content
		(#set! injection.language "json")
))))) 

(block_mapping_pair 
  key: (flow_node 
	(plain_scalar
	  (string_scalar))) 
  value: (block_node 
	(block_scalar 
	  (comment) @cmt (#eq? @cmt "# json")  
	  ) @injection.content 
	 (#set! injection.language "json")
)) 


