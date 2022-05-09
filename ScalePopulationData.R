# Function to normalize data by population
# quantity,popululation are data objects (vectors, matrices, data.frames, etc) of matching dimensions.
# type selects which type of normalization to apply

scale_population_data = function(quantity,population,type=c("wls.a","wls.b","binomial","ratio","none")){
  
  type = match.arg(type)
  
  # Nothing to do in this case
  if(type=="none"){
    return(quantity)
  }
  
  # Verify inputs
  if((length(quantity) != length(population))|!identical(dim(quantity),dim(population))){
    stop("quantity and population dimensions don't match",call.=FALSE)
  }
  if(any(population<=0)){
    stop("population has to be positive", call.= FALSE)
  }
  
  # classic ratio
  if(type == "ratio"){
    return(quantity/population)
  }
  
  # Shared Stuff
  PopT = sum(population,na.rm = TRUE)
  Qty = sum(quantity,na.rm = TRUE)
  P = Qty/PopT 
  
  # Weighted Least Squares methods
  if(type=="wls.a"){
    resid = (quantity - P*population)/sqrt(population)
    n = sum(!(is.na(quantity)&is.na(population)))
    scale_sig = sqrt((n-1)/sum(resid^2,na.rm = TRUE))
    return(resid*scale_sig)
  }
  
  if(type=="wls.b"){
    resid = (quantity - P*population)/sqrt(population)

    scale_sig = 1/sqrt((1-P)*P)
    return(resid*scale_sig)
  }
  
  # Binomial
  if(type == "binomial"){
    # estimate each proportion
    p_i = quantity/population
    var_i = p_i*(1-p_i)/population
    
    # estimate the proportion of the rest
    Pop_t_i = PopT-population # population of set complement
    Qty_t_i = (Qty-quantity) # quantity of set complement
    p_t_i = Qty_t_i/Pop_t_i # proportion of set complement 
    var_t_i = p_t_i*(1-p_t_i)/Pop_t_i
    
    # get estimates for p
    dp = p_i - p_t_i # difference in proportions
    sig_dp = sqrt(var_t_i + var_i) 
    z = dp/sig_dp
    
    return(z)
    
  }
}
