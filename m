Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 42A0D208AE2B5
 for <linux-nvdimm@lists.01.org>; Wed, 27 Feb 2019 23:54:04 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id u128so15792157oie.2
 for <linux-nvdimm@lists.01.org>; Wed, 27 Feb 2019 23:54:04 -0800 (PST)
MIME-Version: 1.0
References: <20190225185727.BCBD768C@viggo.jf.intel.com>
In-Reply-To: <20190225185727.BCBD768C@viggo.jf.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Feb 2019 23:53:52 -0800
Message-ID: <CAPcyv4g8ACK6ZOmDWVVhCAwcoaxRZdXQDt_8D6Omckuop8DapQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] [v5] Allow persistent memory to be used like normal
 RAM
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
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Juergen Gross <jgross@suse.com>, Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, "Huang, Ying" <ying.huang@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

[ add Stephen and Juergen ]

On Mon, Feb 25, 2019 at 11:02 AM Dave Hansen
<dave.hansen@linux.intel.com> wrote:
>
> This is a relatively small delta from v4.  The review comments seem
> to be settling down, so it seems like we should start thinking about
> how this might get merged.  Are there any objections to taking it in
> via the nvdimm tree?
>
> Dan Williams, our intrepid nvdimm maintainer has said he would
> appreciate acks on these from relevant folks before merging them.
> Reviews/acks on any in the series would be welcome, but the last
> two especially are lacking any non-Intel acks:
>
>         mm/resource: let walk_system_ram_range() search child resources
>         dax: "Hotplug" persistent memory for use like normal RAM

I've gone ahead and added this to the libnvdimm-for-next branch for
wider exposure. Acks of course still welcome.

Stephen, this collides with commit 357b4da50a62 "x86: respect memory
size limiting via mem= parameter" in current -next. Here's my
resolution for reference, basically just add the max_mem_size
statement to Dave's rework. Holler if this causes any other problems.

diff --cc mm/memory_hotplug.c
index a9d5787044e1,b37f3a5c4833..c4f59ac21014
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@@ -102,28 -99,21 +102,24 @@@ u64 max_mem_size = U64_MAX
  /* add this memory to iomem resource */
  static struct resource *register_memory_resource(u64 start, u64 size)
  {
-       struct resource *res, *conflict;
+       struct resource *res;
+       unsigned long flags =  IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
+       char *resource_name = "System RAM";

 +      if (start + size > max_mem_size)
 +              return ERR_PTR(-E2BIG);
 +
-       res = kzalloc(sizeof(struct resource), GFP_KERNEL);
-       if (!res)
-               return ERR_PTR(-ENOMEM);
-
-       res->name = "System RAM";
-       res->start = start;
-       res->end = start + size - 1;
-       res->flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
-       conflict =  request_resource_conflict(&iomem_resource, res);
-       if (conflict) {
-               if (conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
-                       pr_debug("Device unaddressable memory block "
-                                "memory hotplug at %#010llx !\n",
-                                (unsigned long long)start);
-               }
-               pr_debug("System RAM resource %pR cannot be added\n", res);
-               kfree(res);
+       /*
+        * Request ownership of the new memory range.  This might be
+        * a child of an existing resource that was present but
+        * not marked as busy.
+        */
+       res = __request_region(&iomem_resource, start, size,
+                              resource_name, flags);
+
+       if (!res) {
+               pr_debug("Unable to reserve System RAM region:
%016llx->%016llx\n",
+                               start, start + size);
                return ERR_PTR(-EEXIST);
        }
        return res;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
