Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x244.google.com (mail-qk0-x244.google.com
 [IPv6:2607:f8b0:400d:c09::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB42A21A13496
 for <linux-nvdimm@lists.01.org>; Wed,  3 May 2017 00:08:05 -0700 (PDT)
Received: by mail-qk0-x244.google.com with SMTP id o4so1516139qkb.3
 for <linux-nvdimm@lists.01.org>; Wed, 03 May 2017 00:08:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g+mf4t=MjawD7hFf5hvs0H2DWMTjvPV3=zAShHpyQvTA@mail.gmail.com>
References: <20170427091552.17694-1-oohall@gmail.com>
 <CAPcyv4id9q+6mKtqqJYzGdVN74Q5=-Rzirizs+U0RiJ-oF2Kyw@mail.gmail.com>
 <CAOSf1CEh379QGym155L6ALxU14xvF5pm6fyN=LDcKM_Q+wFGuA@mail.gmail.com>
 <CAPcyv4gLZiM_rBCOHiUdczTwbVB=QPa-eWVNVrG8tU82LKUjAw@mail.gmail.com>
 <CAOSf1CE2ugvN8WANYA5x-UhLiUA=sH1jTVEZUCR4wW8uGU_EMw@mail.gmail.com>
 <CAPcyv4g+mf4t=MjawD7hFf5hvs0H2DWMTjvPV3=zAShHpyQvTA@mail.gmail.com>
From: "Oliver O'Halloran" <oohall@gmail.com>
Date: Wed, 3 May 2017 17:08:03 +1000
Message-ID: <CAOSf1CHLiO85NN1mo+4AmgDc2RvqNmiLEcp1cANX58Ojn0sSqA@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: Export supported alignments via sysfs
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 3, 2017 at 2:17 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, May 2, 2017 at 8:25 PM, Oliver O'Halloran <oohall@gmail.com> wrote:
>> On Wed, May 3, 2017 at 7:57 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> On Fri, Apr 28, 2017 at 12:31 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
>>>> On Fri, Apr 28, 2017 at 1:59 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>>>>> On Thu, Apr 27, 2017 at 2:15 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
>>>>>> Adds two new sysfs attributes for pfn (and dax) devices:
>>>>>> supported_alignements and default_alignment. These advertise to
>>>>>> userspace what alignments this kernel supports, and provides a nominal
>>>>>> default alignment to use.
>>>>>>
>>>>>> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
>>>>>> ---
>>>>>> I'm not sure it makes sense to provide these for pfn devices. In the dax
>>>>>> case we have hard restrictions because of how fault handling works, but
>>>>>> I'm not convinced this makes sense for the pfn case since it's going to
>>>>>> be used with fs-dax.
>>>>
>>>>> We still want this for fs-dax so we can make sure that the namespace
>>>>> is aligned to allow for opportunistic large mappings. We have pmd
>>>>> support for fs-dax currently shipping, and looking to expand that to
>>>>> pud support.
>>>>
>>>> Sure, but whether we can use a PUD for userspace mappings mostly
>>>> depends on the allocation decisions of the filesystem rather than the
>>>> alignment of the namespace. The reservations for the PFN superblock,
>>>> altmap and dax labels mean the namespace is always going to be
>>>> unaligned so forcing a PUD alignment will result in a lot of wasted
>>>> space for dubious benefits. I suppose there's no reason not to provide
>>>> the functionality, but I don't see it buying us much.
>>>>
>>>>>> ---
>>>>>>  drivers/nvdimm/pfn_devs.c | 26 ++++++++++++++++++++++++++
>>>>>>  1 file changed, 26 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
>>>>>> index 6c033c9a2f06..5157e7d89f0b 100644
>>>>>> --- a/drivers/nvdimm/pfn_devs.c
>>>>>> +++ b/drivers/nvdimm/pfn_devs.c
>>>>>> @@ -260,6 +260,30 @@ static ssize_t size_show(struct device *dev,
>>>>>>  }
>>>>>>  static DEVICE_ATTR_RO(size);
>>>>>>
>>>>>> +static ssize_t supported_alignments_show(struct device *dev,
>>>>>> +               struct device_attribute *attr, char *buf)
>>>>>> +{
>>>>>> +       /* Fun fact: These aren't always constants! */
>>>>>> +       unsigned long supported_alignments[] = {
>>>>>> +               PAGE_SIZE,
>>>>>> +               HPAGE_PMD_SIZE,
>>>>>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>>>>> +               HPAGE_PUD_SIZE,
>>>>>> +#endif
>>>>>> +               0,
>>>>>> +       };
>>>>>> +
>>>>>> +       return nd_sector_size_show(0, supported_alignments, buf);
>>>>>> +}
>>>>>> +DEVICE_ATTR_RO(supported_alignments);
>>>>>> +
>>>>>> +static ssize_t default_alignment_show(struct device *dev,
>>>>>> +               struct device_attribute *attr, char *buf)
>>>>>> +{
>>>>>> +       return sprintf(buf, "%ld\n", HPAGE_PMD_SIZE);
>>>>>> +}
>>>>>> +DEVICE_ATTR_RO(default_alignment);
>>>>>> +
>>>>>>  static struct attribute *nd_pfn_attributes[] = {
>>>>>>         &dev_attr_mode.attr,
>>>>>>         &dev_attr_namespace.attr,
>>>>>> @@ -267,6 +291,8 @@ static struct attribute *nd_pfn_attributes[] = {
>>>>>>         &dev_attr_align.attr,
>>>>>>         &dev_attr_resource.attr,
>>>>>>         &dev_attr_size.attr,
>>>>>> +       &dev_attr_supported_alignments.attr,
>>>>>> +       &dev_attr_default_alignment.attr,
>>>>>>         NULL,
>>>>>
>>>>> So, we don't need DEVICE_ATTR_RO(default_alignment), that can be
>>>>> reflected by setting nd_pfn->align to HPAGE_PMD_SIZE by default.
>>>>
>>>> Hmm true, if we do this then we can use the alignment of the seed as
>>>> the default rather than having a separate attribute.
>>>>
>>>>> passing nd_pfn->align to nd_sector_size_show(). Should probably rename
>>>>> nd_sector_size_show() to nd_size_select_show().
>>>>
>>>> I agree. I figured another respin would be required so I kept the
>>>> changes to a minimum.
>>>>
>>>>> The other concern is that the current DEVICE_ATTR_RW(align) can be
>>>>> made redundant by this new interface if you make it writable. I wonder
>>>>> if we can avoid breaking old ndctl versions by making the current
>>>>> align setting the first one in the output? Worse comes to worse we can
>>>>> live with two attributes 'align' and 'aligns', but I'd like to see if
>>>>> can add this to the existing attribute.
>>>>
>>>> I'd rather have a small amount of redundancy and keep the the
>>>> attribute consistent with the the btt sector size attribute.
>>>
>>> I'd rather not, that's expanding the kernel-user ABI for only vanity
>>> reasons as far as I can see.
>>
>> It's an extension of the user-kernel ABI in any case. This is just the
>> most byzantine way to do it.
>>
>>>> We could
>>>> always remove align some time down the track since I imagine ndctl is
>>>> the only thing that consumes that part of the interface and ndctl
>>>> already handles align being missing.
>>>
>>> No, that breaks old ndctl binaries that depend on the align attribute
>>> to be there if the kernel supports device-dax.
>>
>> Fair enough.
>
> All that said, there's nothing stopping us from making 'align' it's
> own mechanism. Where the first entry in the list is the current
> setting, in contrast to btt that decorates the current sector-size
> setting with square brackets.

I'd be okay with this provided we force the alignment to one of the
supported values. Currently the only validation done by the kernel is:

        if (!is_power_of_2(val) || val < PAGE_SIZE || val > SZ_1G)
                return -EINVAL;

So you can set an unsupported value by poking at sysfs directly. This
behaviour is useful for testing since you can use it to force an
alignment failure in the DAX fault handler. I'm not overly concerned
if it goes, but it's something to keep in mind. I still think it would
be cleaner if we just added a separate attribute.

Oliver
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
