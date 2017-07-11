Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x242.google.com (mail-qk0-x242.google.com
 [IPv6:2607:f8b0:400d:c09::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1A5CA21D147A4
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 21:37:02 -0700 (PDT)
Received: by mail-qk0-x242.google.com with SMTP id q66so4419233qki.1
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 21:38:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jSDP3oJVH4TaMH8POzAjGoRN+QGT2R_xnpB+NsuQVKhA@mail.gmail.com>
References: <20170627095612.6328-1-oohall@gmail.com>
 <CAPcyv4jSDP3oJVH4TaMH8POzAjGoRN+QGT2R_xnpB+NsuQVKhA@mail.gmail.com>
From: Oliver <oohall@gmail.com>
Date: Tue, 11 Jul 2017 14:38:46 +1000
Message-ID: <CAOSf1CEb6DcPgK8FHOo-yvf0V-3eA1WdHdu+nzJcrB-5DE7CMg@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: show supported dax/pfn region alignments in
 sysfs
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

On Tue, Jul 11, 2017 at 9:40 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Jun 27, 2017 at 2:56 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
>> The alignment of a DAX and PFN regions dictates the page sizes that can
>> be used to map the region. Even if the hardware page sizes are known the
>> actual range of supported page sizes that can be used with DAX depends
>> on the kernel configuration. As a result its best that the kernel
>> advertises the alignments that should be used with these region types.
>>
>> This patch adds the 'supported_alignments' region attribute to expose
>> this information to userspace.
>
> Agh, sorry I missed this for 4.13.
>
>>
>> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
>> ---
>>  drivers/nvdimm/pfn_devs.c | 28 ++++++++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
>>
>> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
>> index 2ae9a000b090..505d50ef9a91 100644
>> --- a/drivers/nvdimm/pfn_devs.c
>> +++ b/drivers/nvdimm/pfn_devs.c
>> @@ -260,6 +260,33 @@ static ssize_t size_show(struct device *dev,
>>  }
>>  static DEVICE_ATTR_RO(size);
>>
>> +static ssize_t supported_alignments_show(struct device *dev,
>> +               struct device_attribute *attr, char *buf)
>> +{
>> +       /*
>> +        * This needs to be a local variable because the *_SIZE macros
>> +        * aren't always constants.
>> +        */
>> +       unsigned long supported_alignments[] = {
>> +               PAGE_SIZE,
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +               HPAGE_PMD_SIZE,
>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>> +               HPAGE_PUD_SIZE,
>> +#endif
>> +#endif
>> +               0,
>> +       };
>> +
>> +       return nd_sector_size_show(0, supported_alignments, buf);
>
> Can you go ahead and change nd_sector_size_show() to
> nd_size_list_show() or some other name to reflect that it's just a
> generic helper for an array of possibilities.

Bleh, knew I forgot to do something.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
