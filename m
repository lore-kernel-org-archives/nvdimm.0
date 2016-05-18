Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 188D41A1FB1
 for <linux-nvdimm@lists.01.org>; Wed, 18 May 2016 10:27:04 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id v145so87870156oie.0
 for <linux-nvdimm@lists.01.org>; Wed, 18 May 2016 10:26:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160518171250.GS3528@linux.vnet.ibm.com>
References: <146329357870.17948.14240958684074905846.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146329358943.17948.12857084981536373315.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160517105711.GA3333@c203.arch.suse.de>
 <CAPcyv4guFrgt8vROjPBYngBMSMF8_H3TY99vU93rG+VB+avOPQ@mail.gmail.com>
 <573C22B7.3090706@suse.de>
 <20160518091001.GA12031@fergus.ozlabs.ibm.com>
 <573C329F.2000306@suse.de>
 <20160518171250.GS3528@linux.vnet.ibm.com>
Date: Wed, 18 May 2016 10:26:57 -0700
Message-ID: <CAPcyv4jX94_zC4x6rfGg7q9M8wNMC2=6g-2hf=atVJZ1kUJAKA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] /dev/dax, core: file operations and dax-mmap
From: Dan Williams <dan.j.williams@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: linux-block@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@ozlabs.org>, Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 18, 2016 at 10:12 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, May 18, 2016 at 11:15:11AM +0200, Hannes Reinecke wrote:
>> On 05/18/2016 11:10 AM, Paul Mackerras wrote:
>> > On Wed, May 18, 2016 at 10:07:19AM +0200, Hannes Reinecke wrote:
>> >> On 05/18/2016 12:19 AM, Dan Williams wrote:
>> >>> On Tue, May 17, 2016 at 3:57 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>> >>>> On Sat, May 14, 2016 at 11:26:29PM -0700, Dan Williams wrote:
>> >>>>> The "Device DAX" core enables dax mappings of performance / feature
>> >>>>> differentiated memory.  An open mapping or file handle keeps the backing
>> >>>>> struct device live, but new mappings are only possible while the device
>> >>>>> is enabled.   Faults are handled under rcu_read_lock to synchronize
>> >>>>> with the enabled state of the device.
>> >>>>>
>> >>>>> Similar to the filesystem-dax case the backing memory may optionally
>> >>>>> have struct page entries.  However, unlike fs-dax there is no support
>> >>>>> for private mappings, or mappings that are not backed by media (see
>> >>>>> use of zero-page in fs-dax).
>> >>>>>
>> >>>>> Mappings are always guaranteed to match the alignment of the dax_region.
>> >>>>> If the dax_region is configured to have a 2MB alignment, all mappings
>> >>>>> are guaranteed to be backed by a pmd entry.  Contrast this determinism
>> >>>>> with the fs-dax case where pmd mappings are opportunistic.  If userspace
>> >>>>> attempts to force a misaligned mapping, the driver will fail the mmap
>> >>>>> attempt.  See dax_dev_check_vma() for other scenarios that are rejected,
>> >>>>> like MAP_PRIVATE mappings.
>> >>>>>
>> >>>>> Cc: Jeff Moyer <jmoyer@redhat.com>
>> >>>>> Cc: Christoph Hellwig <hch@lst.de>
>> >>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> >>>>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> >>>>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> >>>>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> >>>>> ---
>> >>>>>  drivers/dax/Kconfig |    1
>> >>>>>  drivers/dax/dax.c   |  316 +++++++++++++++++++++++++++++++++++++++++++++++++++
>> >>>>>  mm/huge_memory.c    |    1
>> >>>>>  mm/hugetlb.c        |    1
>> >>>>>  4 files changed, 319 insertions(+)
>> >>>>>
>> >>>>> diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
>> >>>>> index 86ffbaa891ad..cedab7572de3 100644
>> >>>>> --- a/drivers/dax/Kconfig
>> >>>>> +++ b/drivers/dax/Kconfig
>> >>>>> @@ -1,6 +1,7 @@
>> >>>>>  menuconfig DEV_DAX
>> >>>>>       tristate "DAX: direct access to differentiated memory"
>> >>>>>       default m if NVDIMM_DAX
>> >>>>> +     depends on TRANSPARENT_HUGEPAGE
>> >>>>>       help
>> >>>>>         Support raw access to differentiated (persistence, bandwidth,
>> >>>>>         latency...) memory via an mmap(2) capable character
>> >>>>> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
>> >>>>> index 8207fb33a992..b2fe8a0ce866 100644
>> >>>>> --- a/drivers/dax/dax.c
>> >>>>> +++ b/drivers/dax/dax.c
>> >>>>> @@ -49,6 +49,7 @@ struct dax_region {
>> >>>>>   * @region - parent region
>> >>>>>   * @dev - device backing the character device
>> >>>>>   * @kref - enable this data to be tracked in filp->private_data
>> >>>>> + * @alive - !alive + rcu grace period == no new mappings can be established
>> >>>>>   * @id - child id in the region
>> >>>>>   * @num_resources - number of physical address extents in this device
>> >>>>>   * @res - array of physical address ranges
>> >>>>> @@ -57,6 +58,7 @@ struct dax_dev {
>> >>>>>       struct dax_region *region;
>> >>>>>       struct device *dev;
>> >>>>>       struct kref kref;
>> >>>>> +     bool alive;
>> >>>>>       int id;
>> >>>>>       int num_resources;
>> >>>>>       struct resource res[0];
>> >>>>> @@ -150,6 +152,10 @@ static void destroy_dax_dev(void *_dev)
>> >>>>>
>> >>>>>       dev_dbg(dev, "%s\n", __func__);
>> >>>>>
>> >>>>> +     /* disable and flush fault handlers, TODO unmap inodes */
>> >>>>> +     dax_dev->alive = false;
>> >>>>> +     synchronize_rcu();
>
> If you need to wait for fault handlers, you need synchronize_sched()
> instead of synchronize_rcu().  Please note that synchronize_rcu() is
> guaranteed to wait only for tasks that have done rcu_read_lock() to reach
> the corresponding rcu_read_unlock().  In contrast, synchronize_sched()
> is guaranteed to wait for any non-idle preempt-disable region of code
> to complete, regardless of exactly what is disabling preemptiong.
>
> And the "non-idle" is not an idle qualifier.  If you need to wait on fault
> handlers that somehow occur from an idle hardware thread, you will need
> those fault handlers to do rcu_irq_enter() on entry and rcu_irq_exit()
> on exit.  (My guess is that you cannot take faults in the idle loop,
> but I have learned not to trust such guesses all that far.)
>
> And last, but definitely not least, synchronize_sched() waits only
> for pre-existing preempt-disable regions of code.  So if you do
> synchronize_sched(), and immediately after a fault handler starts,
> synchronize_sched() won't necessarily wait on it.  However, you -are-
> guaranteed that synchronize_shced() -will- wait for any fault handler
> that might possibly see dax_dev->alive with a non-false value.
>
> Are these the guarantees you are looking for?  (Yes, I did recently
> watch "A New Hope".  Why do you ask?)

Spoken like a true rcu-Jedi.

So in this case the fault handlers are indeed running under
rcu_read_lock(), and I can't fathom how these faults would trigger
from an idle thread...

>
>> >>>>> +
>> >>>>
>> >>>> IIRC RCU is only protecting a pointer, not the content of the pointer, so this
>> >>>> looks wrong to me.
>
> RCU can be, and usually is, used to protect pointers, but it can be and
> sometimes is used for other things as well.  At its core, RCU is about
> waiting for pre-existing RCU readers to complete.
>
>> >>> The driver is using RCU to guarantee that all currently running fault
>> >>> handlers have either completed or will see the new state of ->alive
>> >>> when they start.  Reference counts are protecting the actual dax_dev
>> >>> object.
>> >>>
>> >> Hmm.
>> >> This is the same 'creative' RCU usage Mike Snitzer has been trying
>> >> when trying to improve device-mapper performance.
>
> To repeat, unless all your fault handlers begin with rcu_read_lock()
> and end with rcu_read_unlock(), and as long as you don't care about not
> waiting for fault handlers that are currently executing just before
> the rcu_read_lock() and just after the rcu_read_unlock(), you need
> synchronize_sched() rather than synchronize_rcu() for this job.
>
>> >> >From my understanding RCU is protecting the _pointer_, not the
>> >> values of the structure pointed to.
>> >> IOW we are guaranteed to have a valid pointer at any time.
>> >> But at the same time _no_ guarantee is made about the _contents_ of
>> >> the structure.
>> >> It might well be that using 'synchronize_rcu' giving you similar
>> >> results (as synchronize_rcu() is essentially waiting a SMP grace
>> >> period, after which all CPUs should be seeing the update).
>> >> However, I haven't been able to find that this is a guaranteed
>> >> behaviour.
>> >> So from my understanding you have to use locking primitives
>> >> protecting the contents of the structure or exchange the _entire_
>> >> structure if you want to rely on RCU here.
>> >>
>> >> Can we get some clarification here?
>
> Maybe...  What exactly is your synchronization design needing here?
>
>> >> Paul?
>> >
>> > I think you want the other Paul, Paul McKenney.
>> >
>> I think you are in fact right.
>> Sorry for the Paul-confusion :-)
>
> Did I keep my end of the confusion up?  ;-)

Yes, I think we're good, but please double check I am not mistaken in
the following clarification comment:

@@ -150,6 +152,16 @@ static void destroy_dax_dev(void *_dev)

        dev_dbg(dev, "%s\n", __func__);

+       /*
+        * Note, rcu is not protecting the liveness of dax_dev, rcu is
+        * ensuring that any fault handlers that might have seen
+        * dax_dev->alive == true, have completed.  Any fault handlers
+        * that start after synchronize_rcu() has started will abort
+        * upon seeing dax_dev->alive == false.
+        */
+       dax_dev->alive = false;
+       synchronize_rcu();
+
        get_device(dev);
        device_unregister(dev);
        ida_simple_remove(&dax_region->ida, dax_dev->id);
@@ -173,6 +185,7 @@ int devm_create_dax_dev(struct dax_region
*dax_region, struct resource *re
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
