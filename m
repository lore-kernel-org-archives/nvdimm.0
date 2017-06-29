Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x230.google.com (mail-yw0-x230.google.com
 [IPv6:2607:f8b0:4002:c05::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7093F21B02B8B
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 15:41:47 -0700 (PDT)
Received: by mail-yw0-x230.google.com with SMTP id l21so34337988ywb.1
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 15:43:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <595580A6.9000004@hpe.com>
References: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149875884190.10031.6179599135820559644.stgit@dwillia2-desk3.amr.corp.intel.com>
 <595552F5.5040008@hpe.com>
 <CAPcyv4jr0U-a521+wAL7RDca_AoUrtvO6yeY6d0UQpY7d=CHuQ@mail.gmail.com>
 <59556E37.80808@hpe.com>
 <CAPcyv4g6ijkWncZAbP-Bmbf+J7a2hR-JFLSX-ji6v-+oG0PDJQ@mail.gmail.com>
 <d073b4a1-ff90-b44a-adf2-ad44c0d70c69@hpe.com>
 <CAPcyv4huf0ENTz=LEVC6xC7xKRPc-GAZJsZMTSYpy+UoaduTMg@mail.gmail.com>
 <595580A6.9000004@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 15:43:19 -0700
Message-ID: <CAPcyv4gtTYEUELPtr9mi5QkGL+cm=jcFR-Oe07OCuNM9izh6jA@mail.gmail.com>
Subject: Re: [PATCH v4 12/16] libnvdimm,
 nfit: enable support for volatile ranges
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 29, 2017 at 3:35 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 06/29/2017 06:28 PM, Dan Williams wrote:
>> On Thu, Jun 29, 2017 at 3:12 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> [..]
>>>> The /dev/pmem
>>>> device name just tells you that your block device is hosted by a
>>>> driver that knows how to handle persistent memory constraints, but any
>>>> other details about the nature of the address range need to come from
>>>> other sources of information, and potentially information sources that
>>>> the kernel does not know about.
>>>
>>>
>>> I'm asking about the other source of information in this specific case
>>> where we're exposing pmem devices that will never ever be persistent.
>>> Before we add these devices, I think we should be able to tell the user
>>> how they can know the properties of the underlying device.
>>
>> The only way I can think to indicate this is with a platform + device
>> whitelist in a tool like ndctl. Where the tool says "yes, these
>> xyz-vendor DIMMs on this abc-vendor platform with this 123-version
>> BIOS" is a known good persistent configuration.
>
> Doesn't the kernel know that something will never ever be persistent
> because the NFIT type says NFIT_SPA_VDISK, NFIT_SPA_VCD, or NFIT_SPA_VOLATILE?
> That's the case I'm asking about here.   In this patch, you're adding support
> for creating /dev/pmem devices for those address ranges.  My question is
> how the admin/user knows that those devices will never ever be persistent.

The parent region of the namespace will have a 'volatile' type:

# cat /sys/bus/nd/devices/region0/devtype
nd_volatile

> I don't think we need ndctl to know which vendors' hardware/firmware
> actually works as advertised.

Certification stickers is what I was thinking, but I was missing your
direction question.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
