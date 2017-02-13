Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x235.google.com (mail-ot0-x235.google.com
 [IPv6:2607:f8b0:4003:c0f::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 84A6981C73
 for <linux-nvdimm@lists.01.org>; Sun, 12 Feb 2017 17:35:01 -0800 (PST)
Received: by mail-ot0-x235.google.com with SMTP id 32so58741337oth.3
 for <linux-nvdimm@lists.01.org>; Sun, 12 Feb 2017 17:35:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <58A10B25.6030508@jp.fujitsu.com>
References: <148693885124.16345.14319993365448440148.stgit@dwillia2-desk3.amr.corp.intel.com>
 <58A10B25.6030508@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Feb 2017 17:35:00 -0800
Message-ID: <CAPcyv4j0eC3=CPkP6NOMkTpcuik3Ln-D4cj6Nhz50H-srjkbAQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] fix devm_memremap_pages() mem hotplug locking
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
To: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Ben Hutchings <ben@decadent.org.uk>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Feb 12, 2017 at 5:25 PM, Masayoshi Mizuma
<m.mizuma@jp.fujitsu.com> wrote:
> Hi Dan,
>
> On Sun, 12 Feb 2017 14:34:11 -0800 Dan Williams wrote:
>>
>> Ben notes that commit f931ab479dd2 "mm: fix devm_memremap_pages crash,
>> use mem_hotplug_{begin, done}" is incomplete and broken. Writes to
>> mem_hotplug.active_writer need to be coordinated under the device
>> hotplug lock. Otherwise, we can potentially corrupt mem_hotplug.refcount
>> leading to soft lockups.
>
>
> I think mem_hotplug_{begin,done} is not suitable to exclude
> devm_memremap_pages()
> because it seems that memory hotplug is not related to this context.
> How about using pgmap_lock instead?

The problem with that switch is the race in
kernel_physical_mapping_init(), see commit f931ab479dd2. As far as I
can see we need all paths that call kernel_physical_mapping_init() to
agree on the same lock, and can't use a private lock in
devm_memremap_pages().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
