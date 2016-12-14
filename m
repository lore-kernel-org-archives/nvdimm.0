From: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] dev-dax: add support to display badblocks in sysfs
 for dev-dax
Date: Wed, 14 Dec 2016 15:51:45 -0700
Message-ID: <5285b143-5588-2f69-60fe-d7d905999cbb@intel.com>
References: <148158809239.159590.16102609849408268953.stgit@djiang5-desk3.ch.intel.com>
 <x491sxadxkn.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <x491sxadxkn.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org



On 12/14/2016 02:12 PM, Jeff Moyer wrote:
> Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:
> 
>> Adding support to show badblocks in the pmem region that's provided
>> by the poison_list. This should show up in
>> /sys/class/dax/daxN.N/badblocks as read only. Currently we only support
>> a single resource and we do not support badblocks for seeds. Additional
>> support code will be implemented to support.
> 
> You didn't wire up a notify event.  Was that intentional?

No. I totally missed it. Good catch!

> 
> -Jeff
> 
>>
>> Signed-off-by: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/dax/dax.c  |   27 ++++++++++++++++++++++-----
>>  drivers/dax/dax.h  |    8 +++++++-
>>  drivers/dax/pmem.c |   37 ++++++++++++++++++++++++++++++++++++-
>>  3 files changed, 65 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
>> index 6450c07..2c34cae 100644
>> --- a/drivers/dax/dax.c
>> +++ b/drivers/dax/dax.c
>> @@ -83,6 +83,7 @@ struct dax_dev {
>>  	int id;
>>  	int num_resources;
>>  	struct resource **res;
>> +	void *private;
>>  };
>>  
>>  #define for_each_dax_region_resource(dax_region, res) \
>> @@ -408,6 +409,20 @@ static struct dax_dev *to_dax_dev(struct device *dev)
>>  	return container_of(dev, struct dax_dev, dev);
>>  }
>>  
>> +void *dax_dev_get_private(struct device *dev)
>> +{
>> +	struct dax_dev *dax_dev = to_dax_dev(dev);
>> +
>> +	return dax_dev->private;
>> +}
>> +EXPORT_SYMBOL_GPL(dax_dev_get_private);
>> +
>> +void dax_dev_set_private(struct dax_dev *dax_dev, void *priv)
>> +{
>> +	dax_dev->private = priv;
>> +}
>> +EXPORT_SYMBOL_GPL(dax_dev_set_private);
>> +
>>  static unsigned long long dax_dev_size(struct dax_dev *dax_dev)
>>  {
>>  	struct dax_region *dax_region = dax_dev->region;
>> @@ -805,7 +820,7 @@ static ssize_t dax_dev_resize(struct dax_region *dax_region,
>>  			&& &dax_dev->dev == dax_region->seed) {
>>  		struct dax_dev *seed;
>>  
>> -		seed = devm_create_dax_dev(dax_region, NULL, 0);
>> +		seed = devm_create_dax_dev(dax_region, NULL, 0, NULL);
>>  		if (IS_ERR(seed))
>>  			dev_warn(dax_region->dev,
>>  					"failed to create new region seed\n");
>> @@ -851,9 +866,10 @@ static struct attribute *dax_device_attributes[] = {
>>  	NULL,
>>  };
>>  
>> -static const struct attribute_group dax_device_attribute_group = {
>> +struct attribute_group dax_device_attribute_group = {
>>  	.attrs = dax_device_attributes,
>>  };
>> +EXPORT_SYMBOL_GPL(dax_device_attribute_group);
>>  
>>  static const struct attribute_group *dax_attribute_groups[] = {
>>  	&dax_device_attribute_group,
>> @@ -1143,7 +1159,8 @@ static void dax_dev_release(struct device *dev)
>>  }
>>  
>>  struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
>> -		struct resource *res, int count)
>> +		struct resource *res, int count,
>> +		const struct attribute_group **groups)
>>  {
>>  	struct device *parent = dax_region->dev;
>>  	struct dax_dev *dax_dev;
>> @@ -1248,7 +1265,7 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
>>  	dev->devt = dev_t;
>>  	dev->class = dax_class;
>>  	dev->parent = parent;
>> -	dev->groups = dax_attribute_groups;
>> +	dev->groups = groups ? groups : dax_attribute_groups;
>>  	dev->release = dax_dev_release;
>>  	dev_set_name(dev, "dax%d.%d", dax_region->id, dax_dev->id);
>>  	/* update resource names now that the owner device is named */
>> @@ -1268,7 +1285,7 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
>>  	if (atomic_inc_return(&dax_region->child_count) == 1) {
>>  		struct dax_dev *seed;
>>  
>> -		seed = devm_create_dax_dev(dax_region, NULL, 0);
>> +		seed = devm_create_dax_dev(dax_region, NULL, 0, NULL);
>>  		if (IS_ERR(seed))
>>  			dev_warn(parent, "failed to create region seed\n");
>>  		else
>> diff --git a/drivers/dax/dax.h b/drivers/dax/dax.h
>> index ddd829a..c23c7ac 100644
>> --- a/drivers/dax/dax.h
>> +++ b/drivers/dax/dax.h
>> @@ -16,10 +16,16 @@ struct device;
>>  struct dax_dev;
>>  struct resource;
>>  struct dax_region;
>> +extern struct attribute_group dax_device_attribute_group;
>> +
>>  void dax_region_put(struct dax_region *dax_region);
>>  struct dax_region *alloc_dax_region(struct device *parent,
>>  		int region_id, struct resource *res, unsigned int align,
>>  		void *addr, unsigned long flags);
>>  struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
>> -		struct resource *res, int count);
>> +		struct resource *res, int count,
>> +		const struct attribute_group **groups);
>> +void *dax_dev_get_private(struct device *dev);
>> +void dax_dev_set_private(struct dax_dev *dax_dev, void *priv);
>> +
>>  #endif /* __DAX_H__ */
>> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
>> index 033f49b3..808d3bb 100644
>> --- a/drivers/dax/pmem.c
>> +++ b/drivers/dax/pmem.c
>> @@ -14,6 +14,7 @@
>>  #include <linux/memremap.h>
>>  #include <linux/module.h>
>>  #include <linux/pfn_t.h>
>> +#include <linux/badblocks.h>
>>  #include "../nvdimm/pfn.h"
>>  #include "../nvdimm/nd.h"
>>  #include "dax.h"
>> @@ -22,6 +23,32 @@ struct dax_pmem {
>>  	struct device *dev;
>>  	struct percpu_ref ref;
>>  	struct completion cmp;
>> +	struct badblocks bb;
>> +};
>> +
>> +static ssize_t dax_pmem_badblocks_show(struct device *dev,
>> +		struct device_attribute *attr, char *page)
>> +{
>> +	struct dax_pmem *dax_pmem =
>> +		(struct dax_pmem *)dax_dev_get_private(dev);
>> +
>> +	return badblocks_show(&dax_pmem->bb, page, 0);
>> +}
>> +static DEVICE_ATTR(badblocks, S_IRUGO, dax_pmem_badblocks_show, NULL);
>> +
>> +static struct attribute *dax_pmem_badblock_attributes[] = {
>> +	&dev_attr_badblocks.attr,
>> +	NULL,
>> +};
>> +
>> +static struct attribute_group dax_pmem_badblock_attribute_group = {
>> +	.attrs = dax_pmem_badblock_attributes,
>> +};
>> +
>> +static const struct attribute_group *dax_pmem_attribute_groups[] = {
>> +	&dax_device_attribute_group,
>> +	&dax_pmem_badblock_attribute_group,
>> +	NULL,
>>  };
>>  
>>  static struct dax_pmem *to_dax_pmem(struct percpu_ref *ref)
>> @@ -130,7 +157,15 @@ static int dax_pmem_probe(struct device *dev)
>>  		return -ENOMEM;
>>  
>>  	/* TODO: support for subdividing a dax region... */
>> -	dax_dev = devm_create_dax_dev(dax_region, &res, 1);
>> +	dax_dev = devm_create_dax_dev(dax_region, &res, 1,
>> +			dax_pmem_attribute_groups);
>> +	dax_dev_set_private(dax_dev, dax_pmem);
>> +
>> +	rc = devm_init_badblocks(dev, &dax_pmem->bb);
>> +	if (rc)
>> +		return rc;
>> +
>> +	nvdimm_badblocks_populate(nd_region, &dax_pmem->bb, &res);
>>  
>>  	/* child dax_dev instances now own the lifetime of the dax_region */
>>  	dax_region_put(dax_region);
>>
>> _______________________________________________
>> Linux-nvdimm mailing list
>> Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
>> https://lists.01.org/mailman/listinfo/linux-nvdimm
