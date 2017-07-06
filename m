Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x230.google.com (mail-yb0-x230.google.com
 [IPv6:2607:f8b0:4002:c09::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8576920958985
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 19:07:15 -0700 (PDT)
Received: by mail-yb0-x230.google.com with SMTP id e201so1875419ybb.1
 for <linux-nvdimm@lists.01.org>; Wed, 05 Jul 2017 19:08:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1499303324.2042.7.camel@hpe.com>
References: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149875884190.10031.6179599135820559644.stgit@dwillia2-desk3.amr.corp.intel.com>
 <595552F5.5040008@hpe.com>
 <CAPcyv4jr0U-a521+wAL7RDca_AoUrtvO6yeY6d0UQpY7d=CHuQ@mail.gmail.com>
 <59556E37.80808@hpe.com>
 <CAPcyv4g6ijkWncZAbP-Bmbf+J7a2hR-JFLSX-ji6v-+oG0PDJQ@mail.gmail.com>
 <d073b4a1-ff90-b44a-adf2-ad44c0d70c69@hpe.com>
 <CAPcyv4huf0ENTz=LEVC6xC7xKRPc-GAZJsZMTSYpy+UoaduTMg@mail.gmail.com>
 <595580A6.9000004@hpe.com>
 <CAPcyv4gtTYEUELPtr9mi5QkGL+cm=jcFR-Oe07OCuNM9izh6jA@mail.gmail.com>
 <d545a1ea-0199-7462-58c5-067cdc22cacc@hpe.com>
 <CAPcyv4gnkpWXJ7jOJ7r0kWLKoLfuqJzdHTjANBUPztyTWUrOjA@mail.gmail.com>
 <595589CF.5010605@hpe.com>
 <CAPcyv4iTaXc92ggQcBnqJ=P0jsMF9HhnV4nAsr1Qos4pjrRDLA@mail.gmail.com>
 <1499297819.2042.5.camel@hpe.com>
 <CAPcyv4ixQFNT_8tGFyf2ABqxpPd-jmtXKVeLBRdzBW12u3TJbg@mail.gmail.com>
 <1499303324.2042.7.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 5 Jul 2017 19:08:54 -0700
Message-ID: <CAPcyv4gL25svXg=7dmftmxMoqd7Fns_JV1WsGx_iFXRGBJT-CA@mail.gmail.com>
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "x86@kernel.org" <x86@kernel.org>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

[ adding Jeff, and Johannes ]

On Wed, Jul 5, 2017 at 6:17 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Wed, 2017-07-05 at 17:07 -0700, Dan Williams wrote:
[..]
>> We have symlinks in /dev/disk/by* to make it easier to identify
>> storage devices, I think it makes sense to add udev rules for
>> identifying volatile pmem and not try to differentiate this in the
>> default kernel device name.
>
> I am not sure what might be a good way, but I am concerned because a
> single block device naming do not represent both volatile and
> persistent media today.

We do have time to changes this if we find out this is critical. Maybe
it's best to ask Linux distro folks what would be easier for them?

Jeff, Johannes, any thoughts on whether we should produce a
"/dev/vmemX" device when we know the backing memory range is volatile?
In this patch everything shows up as /dev/pmemX and you need to look
elsewhere in sysfs to find that the memory range is defined as
volatile by the NFIT.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
