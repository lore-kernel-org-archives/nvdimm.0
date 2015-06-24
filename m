Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iBD0ON_M3rMC3bQz2dGWdt_QKGzfbuqtLSrL+PVu9VbA@mail.gmail.com>
References: <1434737914-18466-1-git-send-email-toshi.kani@hp.com>
	<1434737914-18466-4-git-send-email-toshi.kani@hp.com>
	<CAPcyv4iBD0ON_M3rMC3bQz2dGWdt_QKGzfbuqtLSrL+PVu9VbA@mail.gmail.com>
Date: Tue, 23 Jun 2015 17:36:45 -0700
Message-ID: <CAPcyv4h+oiuERyPTDJHG-079okOCDe85XprRmLrHoGtt1cYuzA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] libnvdimm: Add sysfs numa_node to NVDIMM devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 23, 2015 at 5:26 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, Jun 19, 2015 at 11:18 AM, Toshi Kani <toshi.kani@hp.com> wrote:
>> Add support of sysfs 'numa_node' to I/O-related NVDIMM devices
>> under /sys/bus/nd/devices, regionN, namespaceN.0, and bttN.
>> When bttN is not set up, its numa_node returns -1 (NUMA_NO_NODE).
>>
>> An example of numa_node values on a 2-socket system with a single
>> NVDIMM range on each socket is shown below.
>>   /sys/bus/nd/devices
>>   |-- btt0/numa_node:-1
>>   |-- btt1/numa_node:0
>>   |-- namespace0.0/numa_node:0
>>   |-- namespace1.0/numa_node:1
>>   |-- region0/numa_node:0
>>   |-- region1/numa_node:1
>>
>> These numa_node files are then linked under the block class of
>> their device names.
>>   /sys/class/block/pmem0/device/numa_node:0
>>   /sys/class/block/pmem0s/device/numa_node:0
>>   /sys/class/block/pmem1/device/numa_node:1
>>
>> This enables numactl(8) to accept 'block:' and 'file:' paths of
>> pmem and btt devices as shown in the examples below.
>>   numactl --preferred block:pmem0 --show
>>   numactl --preferred file:/dev/pmem0s --show
>>
>> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
>> ---
>>  drivers/acpi/nfit.c             |    1 +
>>  drivers/nvdimm/btt_devs.c       |    1 +
>>  drivers/nvdimm/bus.c            |   30 ++++++++++++++++++++++++++++++
>>  drivers/nvdimm/namespace_devs.c |    1 +
>>  include/linux/libnvdimm.h       |    1 +
>>  5 files changed, 34 insertions(+)
>>
>> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
>> index 5997753..9cb63ac 100644
>> --- a/drivers/acpi/nfit.c
>> +++ b/drivers/acpi/nfit.c
>> @@ -873,6 +873,7 @@ static const struct attribute_group *acpi_nfit_region_attribute_groups[] = {
>>         &nd_region_attribute_group,
>>         &nd_mapping_attribute_group,
>>         &nd_device_attribute_group,
>> +       &nd_numa_attribute_group,
>>         &acpi_nfit_region_attribute_group,
>>         NULL,
>>  };
>> diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
>> index bcf77dc..a7b192f 100644
>> --- a/drivers/nvdimm/btt_devs.c
>> +++ b/drivers/nvdimm/btt_devs.c
>> @@ -308,6 +308,7 @@ static struct attribute_group nd_btt_attribute_group = {
>>  static const struct attribute_group *nd_btt_attribute_groups[] = {
>>         &nd_btt_attribute_group,
>>         &nd_device_attribute_group,
>> +       &nd_numa_attribute_group,
>>         NULL,
>>  };
>>
>> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
>> index 67525f9..03c0ee1 100644
>> --- a/drivers/nvdimm/bus.c
>> +++ b/drivers/nvdimm/bus.c
>> @@ -420,6 +420,36 @@ struct attribute_group nd_device_attribute_group = {
>>  };
>>  EXPORT_SYMBOL_GPL(nd_device_attribute_group);
>>
>> +static ssize_t numa_node_show(struct device *dev,
>> +               struct device_attribute *attr, char *buf)
>> +{
>> +       return sprintf(buf, "%d\n", dev_to_node(dev));
>> +}
>
> So patch 2 collided with the requested BTT stacking rework and
> prompted me to take a closer look.  Shouldn't numa_node_show() be
> changed like this?
>
> @@ -273,7 +273,12 @@ EXPORT_SYMBOL_GPL(nd_device_attribute_group);
>  static ssize_t numa_node_show(struct device *dev,
>                 struct device_attribute *attr, char *buf)
>  {
> -       return sprintf(buf, "%d\n", dev_to_node(dev));
> +       if (is_nd_region(dev))
> +               return sprintf(buf, "%d\n", dev_to_node(dev));
> +       else if (is_nd_region(dev->parent))
> +               return sprintf(buf, "%d\n", dev_to_node(dev->parent));
> +       else
> +               return sprintf(buf, "-1\n");
>  }
>  static DEVICE_ATTR_RO(numa_node);

Where is_nd_region() is:

+static bool is_nd_region(struct device *dev)
+{
+       if (is_nd_pmem(dev) || is_nd_blk(dev))
+               return true;
+       return false;
+}
+
