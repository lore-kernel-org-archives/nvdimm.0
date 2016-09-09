Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5ECD01A1DF8
 for <linux-nvdimm@lists.01.org>; Thu,  8 Sep 2016 20:57:35 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id y2so113822077oie.0
 for <linux-nvdimm@lists.01.org>; Thu, 08 Sep 2016 20:57:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1473380906.3095.9.camel@intel.com>
References: <147337760801.38083.16900960834862325097.stgit@djiang5-desk3.ch.intel.com>
 <1473380906.3095.9.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Sep 2016 20:57:34 -0700
Message-ID: <CAPcyv4jtM0p6VhcS3f3UhE4YyVk9+TjTXBLXAUJ_meshm80C9w@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: allow legacy (e820) pmem region to clear bad
 blocks
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 8, 2016 at 5:28 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Thu, 2016-09-08 at 16:33 -0700, Dave Jiang wrote:
>> Bad blocks can be injected via /sys/block/pmemN/badblocks. In a
>> situation
>> where legacy pmem is being used or a pmem region created by using
>> memmap
>> kernel parameter, the injected bad blocks are not cleared due to
>> nvdimm_clear_poison() failing from lack of ndctl function pointer. In
>> this case we need to just return as handled and allow the bad blocks
>> to
>> be cleared rather than fail.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  drivers/nvdimm/bus.c |    6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> Looks good to me!
> Reveiewed-by: Vishal Verma <Vishal.l.verma@intel.com>

Applied, although I just noticed that patchwork did not pick up that
reviewed-by due to the typo.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
