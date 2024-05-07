
## install-Uncomment if it not already installed
#if (!require("remotes")) install.packages("remotes")
#remotes::install_github("natverse/neuronbridger")

## use 
library(neuronbridger)

#---- 
##Get MIP information for a connectome neuron

## What neurons can be searched using NeuronBridge?
all.nb.ids = neuronbridge_ids()
length(neuronbridge_ids)

# I am interested in the hemibrain neuron, 542634818. 
## Do we have it?
id = "542634818"
id%in%all.nb.ids
## Yes!

#What do we have on it?
nb.info = neuronbridge_info(id)
View(nb.info)
## So here you see one entry because only one MIP file matches the given ID
## In some cases, esp. for GAL4 line, there may be multiple entries because multiple images for stochastic labelling have been taken.
## In this data frame, you find interesting fields such as the dataset the ID if from (libraryName), the locations at which NeuronBridge saves
## MIP files related to this neuron, the gender of the fly brain from which this data item came.
## Importantly there is an internal NeuronBridge ID for this data item (nb.id, 2820604089967050763).
## Every MIP has its own nb.id because multiple MIPs could relate to the same GAL4 line.
## see ?neuronbridge_info

# Let us now see the related MIP file
dm1.mip = neuronbridge_mip(id)
## This gets every MIP file associated with id

# Plot the MIP image in an rgl viewer
plot_mip(dm1.mip)

#----

##Searching for hits among genetic driver lines


# In order to look for hits, we need the nb.id not the id
## Why? Well in this case it is moot, but for some data items, i..e GAL4 lines rather than hemibrain neurons, there are multiple MIP files
## Each one may be from a different MCFO experiment, i.e. a different random subset of neurons contained in the full line.
## The id would specify all of these files. The nb.id specifies just the one with which you wish to search.
nb.id = nb.info$nb.id
length(nb.id)
# We just have one

# Find information on hits
nb.hits = neuronbridge_hits(nb.id=nb.id)
## This data frame is already ranked so that the top hits are at the top.

# We can see the top 10 hits
View(nb.hits[1:10,])
## Looks like the Gen1 GMR GAL4 lines R84D10 and R26B04 target the DM1 uPN.
## We could design a split-GAL4 line using hemidrivers from these lines.
## Though they are likely to also give us similar looking PNs that are not
## the DM1 uPN, in addition to the DM1 uPN ....

# We can take a quick look at the score distribution
hist(nb.hits$normalizedScore)
## As expected, most lines are not going to contain our neuron!

# Let us scan through our top 10 hits and see what they look like
scan_mip(mips = nb.hits, no.hits = 10)

# Good, some nice looking possibilities there.
## We have saved a lot of MIP files in our local directory.
## Which is good if we wish to keep accessing them, but we can clear with:
#neuronbridge_remove_mips()

# This said, best practice would be to set the option 'neuronbridger' to a location
## on your computer, where MIP files cna be downloaded and view at your leisure. I.e.
#options(neuronbridger="C:\Users\chend\Documents\neuronbridger\MIPS_test")

#----

##Filtering for best hits 

#Uncomment to install
#if (!require("hemibrainr")) remotes::install_github("flyconnectome/hemibrainr")

# Load package to examine hemibrain data
library(neuprintr)



# Get all olfactory PNs
all.pns = neuprintr::neuprint_read_neurons(hemibrainr::pn.ids)
## There's a lot of neurons to grab, it might take a while

# Now plot!
nat::nopen3d()
hemibrainr::hemibrain_view()
plot3d(all.pns[id], col = "black", lwd = 5, soma = 1000) # in black, the DM1 uPN
plot3d(all.pns, soma = 500, lwd = 0.5, alpha = 0.25)

# See the problem?
## These are all different neurons, and many different neuron types. There is only oneDM1 uPN. 
## However, there is a lot that looks similar that might also be labelled by the same lines.
