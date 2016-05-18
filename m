Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] /dev/dax, core: file operations and dax-mmap
References: <146329357870.17948.14240958684074905846.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146329358943.17948.12857084981536373315.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160517105711.GA3333@c203.arch.suse.de>
 <CAPcyv4guFrgt8vROjPBYngBMSMF8_H3TY99vU93rG+VB+avOPQ@mail.gmail.com>
 <573C22B7.3090706@suse.de> <20160518091001.GA12031@fergus.ozlabs.ibm.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <573C329F.2000306@suse.de>
Date: Wed, 18 May 2016 11:15:11 +0200
MIME-Version: 1.0
In-Reply-To: <20160518091001.GA12031@fergus.ozlabs.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Mackerras <paulus@ozlabs.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Johannes Thumshirn <jthumshirn@suse.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 05/18/2016 11:10 AM, Paul Mackerras wrote:
> On Wed, May 18, 2016 at 10:07:19AM +0200, Hannes Reinecke wrote:
>> On 05/18/2016 12:19 AM, Dan Williams wrote:
>>> On Tue, May 17, 2016 at 3:57 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>>>> On Sat, May 14, 2016 at 11:26:29PM -0700, Dan Williams wrote:
>>>>> The "Device DAX" core enables dax mappings of performance / feature
>>>>> differentiated memory.  An open mapping or file handle keeps the backing
>>>>> struct device live, but new mappings are only possible while the device
>>>>> is enabled.   Faults are handled under rcu_read_lock to synchronize
>>>>> with the enabled state of the device.
>>>>>
>>>>> Similar to the filesystem-dax case the backing memory may optionally
>>>>> have struct page entries.  However, unlike fs-dax there is no support
>>>>> for private mappings, or mappings that are not backed by media (see
>>>>> use of zero-page in fs-dax).
>>>>>
>>>>> Mappings are always guaranteed to match the alignment of the dax_region.
>>>>> If the dax_region is configured to have a 2MB alignment, all mappings
>>>>> are guaranteed to be backed by a pmd entry.  Contrast this determinism
>>>>> with the fs-dax case where pmd mappings are opportunistic.  If userspace
>>>>> attempts to force a misaligned mapping, the driver will fail the mmap
>>>>> attempt.  See dax_dev_check_vma() for other scenarios that are rejected,
>>>>> like MAP_PRIVATE mappings.
>>>>>
>>>>> Cc: Jeff Moyer <jmoyer@redhat.com>
>>>>> Cc: Christoph Hellwig <hch@lst.de>
>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>>>>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>>>>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>>>>> ---
>>>>>  drivers/dax/Kconfig |    1
>>>>>  drivers/dax/dax.c   |  316 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>  mm/huge_memory.c    |    1
>>>>>  mm/hugetlb.c        |    1
>>>>>  4 files changed, 319 insertions(+)
>>>>>
>>>>> diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
>>>>> index 86ffbaa891ad..cedab7572de3 100644
>>>>> --- a/drivers/dax/Kconfig
>>>>> +++ b/drivers/dax/Kconfig
>>>>> @@ -1,6 +1,7 @@
>>>>>  menuconfig DEV_DAX
>>>>>       tristate "DAX: direct access to differentiated memory"
>>>>>       default m if NVDIMM_DAX
>>>>> +     depends on TRANSPARENT_HUGEPAGE
>>>>>       help
>>>>>         Support raw access to differentiated (persistence, bandwidth,
>>>>>         latency...) memory via an mmap(2) capable character
>>>>> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
>>>>> index 8207fb33a992..b2fe8a0ce866 100644
>>>>> --- a/drivers/dax/dax.c
>>>>> +++ b/drivers/dax/dax.c
>>>>> @@ -49,6 +49,7 @@ struct dax_region {
>>>>>   * @region - parent region
>>>>>   * @dev - device backing the character device
>>>>>   * @kref - enable this data to be tracked in filp->private_data
>>>>> + * @alive - !alive + rcu grace period == no new mappings can be established
>>>>>   * @id - child id in the region
>>>>>   * @num_resources - number of physical address extents in this device
>>>>>   * @res - array of physical address ranges
>>>>> @@ -57,6 +58,7 @@ struct dax_dev {
>>>>>       struct dax_region *region;
>>>>>       struct device *dev;
>>>>>       struct kref kref;
>>>>> +     bool alive;
>>>>>       int id;
>>>>>       int num_resources;
>>>>>       struct resource res[0];
>>>>> @@ -150,6 +152,10 @@ static void destroy_dax_dev(void *_dev)
>>>>>
>>>>>       dev_dbg(dev, "%s\n", __func__);
>>>>>
>>>>> +     /* disable and flush fault handlers, TODO unmap inodes */
>>>>> +     dax_dev->alive = false;
>>>>> +     synchronize_rcu();
>>>>> +
>>>>
>>>> IIRC RCU is only protecting a pointer, not the content of the pointer, so this
>>>> looks wrong to me.
>>>
>>> The driver is using RCU to guarantee that all currently running fault
>>> handlers have either completed or will see the new state of ->alive
>>> when they start.  Reference counts are protecting the actual dax_dev
>>> object.
>>>
>> Hmm.
>> This is the same 'creative' RCU usage Mike Snitzer has been trying
>> when trying to improve device-mapper performance.
>>
>> >From my understanding RCU is protecting the _pointer_, not the
>> values of the structure pointed to.
>> IOW we are guaranteed to have a valid pointer at any time.
>> But at the same time _no_ guarantee is made about the _contents_ of
>> the structure.
>> It might well be that using 'synchronize_rcu' giving you similar
>> results (as synchronize_rcu() is essentially waiting a SMP grace
>> period, after which all CPUs should be seeing the update).
>> However, I haven't been able to find that this is a guaranteed
>> behaviour.
>> So from my understanding you have to use locking primitives
>> protecting the contents of the structure or exchange the _entire_
>> structure if you want to rely on RCU here.
>>
>> Can we get some clarification here?
>> Paul?
> 
> I think you want the other Paul, Paul McKenney.
> 
I think you are in fact right.
Sorry for the Paul-confusion :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N�rnberg
GF: F. Imend�rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N�rnberg)
