Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7645B211E2721
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 19:55:32 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id d5-v6so19768473oib.5
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 19:55:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180611162630.GH17756@stefanha-x1.localdomain>
References: <e74aee54657de6f8d643a92ba21f467db149c2c8.1528714312.git.yi.z.zhang@linux.intel.com>
 <20180611162630.GH17756@stefanha-x1.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Jun 2018 19:55:30 -0700
Message-ID: <CAPcyv4jJSYiCu_qNWgU8KR3sFQE032Uu6LCQq-CTxF0jpkooiA@mail.gmail.com>
Subject: Re: [Qemu-devel] [RFC PATCH 1/1] nvdimm: let qemu requiring section
 alignment of pmem resource.
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Zhang Yi <yi.z.zhang@linux.intel.com>, Igor Mammedov <imammedo@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 11, 2018 at 9:26 AM, Stefan Hajnoczi <stefanha@redhat.com> wrote:
> On Mon, Jun 11, 2018 at 06:54:25PM +0800, Zhang Yi wrote:
>> Nvdimm driver use Memory hot-plug APIs to map it's pmem resource,
>> which at a section granularity.
>>
>> When QEMU emulated the vNVDIMM device, decrease the label-storage,
>> QEMU will put the vNVDIMMs directly next to one another in physical
>> address space, which means that the boundary between them won't
>> align to the 128 MB memory section size.
>
> I'm having a hard time parsing this.
>
> Where does the "128 MB memory section size" come from?  ACPI?
> A chipset-specific value?
>

The devm_memremap_pages() implementation use the memory hotplug core
to allocate the 'struct page' array/map for persistent memory. Memory
hotplug can only be performed in terms of sections, 128MB on x86_64.
There is some limited support for allowing devm_memremap_pages() to
overlap 'System RAM' within a given section, but it does not currently
support multiple devm_memremap_pages() calls overlapping within the
same section. There is currently a kernel bug where we do not handle
this unsupported configuration gracefully. The fix will cause
configurations configurations that try to overlap 2 persistent memory
ranges in the same section to fail.

The proposed fix is trying to make sure that QEMU does not run afoul
of this constraint.

There is currently no line of sight to reduce the minimum memory
hotplug alignment size to less than 128M. Also, as other architectures
outside of x86_64 add devm_memremap_pages() support, the minimum
section alignment constraint might change and is a property of a guest
OS. My understanding is that some guest OSes might expect an even
larger persistent memory minimum alignment.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
