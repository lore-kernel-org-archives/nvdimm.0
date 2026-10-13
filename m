Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC923BA239
	for <nvdimm@lists.linux.dev>; Tue, 13 Oct 2026 08:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791881181; cv=none; b=Q/qS9Kh4pVDsvprczNsON05EcEB0DRFWX8WpTXGTQc5WdMbP17Rh3E7YwJr9bnX1+niYuyc/jvHXiARn766h4LV/ODiF2UZymiRqKny8rJWkZNmXB7JT4L1WrGmfp6pctubU9zabXF4gx245LxbYWB3P74swTv5goSTr/zFga+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791881181; c=relaxed/simple;
	bh=H8lllLIff+92B/hWmTd9yFlU51GFwgtXNyQSmhu85r0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=cvjxyI4m/e0P8H/LEnP73J6o6en1t1hGJUwtAWPJFf4xkwcPadGgC27vsj3nY2639Gj6iRzOl+Eww2ReNZM1pOodgvGT+0ev03Nfp1IEbzj8qYQZAryoA4J3wtxsezmtJiPTzbFLEVkHczqlobuqApnQa6lxGTOmNFhRnR9XTws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eLblAugI; arc=none smtp.client-ip=91.218.175.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eLblAugI"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=H8lllLIff+92B/hWmTd9yFlU51GFwgtXNyQSmhu85r0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791881177; v=1; x=1792485977;
 b=eLblAugII24POJZpKCdUXBMbM1wuHxxYb5gjVYuK7hExZIYriB6nqhDu8jRNI11ses6cnNP2
 nr4Q71jWLhEjU1NdePsKO7JyNxxG0HrAH9KYzmHvRKxg+IGDBgpAd50E3eblhAXREj6ypC8YWLM
 zuVzfmrDeJJT8MAB3mx+i4oY=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9fa3813cf037b6ce;
	Tue, 13 Oct 2026 08:46:17 +0000
X-Mizu-Trace-ID: 9fa3813cf037b6ce
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v3 2/2] dax/bus: fix Device DAX range alignment validation
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <as15T35oOudDM64C@aschofie-mobl2.lan>
Date: Tue, 13 Oct 2026 16:45:59 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Joao Martins <joao.m.martins@oracle.com>,
 nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BE74CAF6-371A-43DB-835A-65C799C5A7B9@linux.dev>
References: <20260924025035.1265035-1-songmuchun@bytedance.com>
 <20260924025035.1265035-3-songmuchun@bytedance.com>
 <as15T35oOudDM64C@aschofie-mobl2.lan>
To: Alison Schofield <alison.schofield@intel.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 13, 2026, at 08:20, Alison Schofield =
<alison.schofield@intel.com> wrote:
>=20
> On Thu, Sep 24, 2026 at 10:50:35AM +0800, Muchun Song wrote:
>> dev_dax->align describes the page size used by a Device DAX mapping.
>> Both the start and size of every range must therefore be aligned to =
it;
>> otherwise the starting PFN cannot represent a naturally aligned page =
of
>> that size.
>>=20
>> Only range sizes are currently validated. A dynamic device can =
therefore
>> select a large-page alignment and allocate a range whose start is not
>> naturally aligned to that page size. The device binds successfully, =
but a
>> subsequent write to a userspace mapping may trigger a kernel panic.
>>=20
>> The automatic resize path can also split a size-aligned request =
across
>> arbitrary free gaps. When devices with different alignments fragment =
a
>> region, this can extend a range by less than its alignment. A later
>> allocation then fails, leaving the failed resize partially applied.
>>=20
>> Validate both the start and size of allocated and adjusted ranges. =
Make
>> the resize path account only for usable aligned space before changing =
any
>> ranges, and skip gaps that cannot satisfy the device alignment. =
Initialize
>> the device alignment before allocating its initial range so that all
>> allocations use the same validation. Perform size validation under =
the
>> same locks as alignment updates so the alignment cannot change before
>> resizing begins.
>>=20
>> A mapping with an unaligned start is now rejected with -EINVAL, while =
a
>> naturally aligned mapping still binds successfully.
>=20
> Hi Muchun,

Hi Alison,

>=20
> The commit message could be condensed. I think the two failure =
scenarios and
> the changes needed to address them are sufficient.Implementation =
details
> are excessive.

Yes, I'll trim the commit message.

>=20
> But before that, need to address something else, see below-
>=20
>>=20
>> Fixes: 6d82120f4156 ("device-dax: add an 'align' attribute")
>> Assisted-by: LLM
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> v3:
>> - Serialize size alignment validation with alignment updates to avoid =
a
>>  partial shrink after a concurrent alignment change (reported by =
Sashiko)
>> - Document the size validation serialization in the commit message
>>=20
>> v2:
>> - Keep the alloc_is_aligned() name to avoid unrelated helper renaming
>>  (suggested by Dave Jiang)
>> - Move this patch after the mapping error reporting fix for =
independent
>>  backports (suggested by Dave Jiang)
>> ---
>> drivers/dax/bus.c | 144 =
+++++++++++++++++++++++++++++++++++-----------
>> 1 file changed, 109 insertions(+), 35 deletions(-)
>>=20
>> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
>=20
> snip
>=20
>=20
>> @@ -1468,6 +1542,7 @@ static struct dev_dax =
*__devm_create_dev_dax(struct dev_dax_data *data)
>> 	return ERR_PTR(-ENOMEM);
>>=20
>> 	dev_dax->region =3D dax_region;
>> + 	dev_dax->align =3D dax_region->align;
>=20
>=20
> Moving this assignment means that initial allocations for static
> pmem regions now go through the new range_is_aligned() check.
>=20
> I'm concerned this may reject existing namespaces with 4K alignment.
> nd_pfn_validate() doesn't require the data offset to be aligned to
> memremap_compat_align(), and older namespace formats may have offsets
> that don't meet that requirement.
>=20
> Can you check whether an existing namespace with such an offset
> would still probe successfully after this change?

Good catch.

I reproduced this with a 4K-aligned, map=3Dmem Device DAX namespace
created by Linux 4.19:

  ndctl create-namespace -f -e namespace0.0 \
          --mode=3Ddevdax --align=3D4K --map=3Dmem

The namespace has a version 1.2 info block with an alignment of 0x1000
and a data offset of 0x22000. Its data range therefore starts at
0x240022000, which is 4K aligned but not 2M aligned.

The namespace probed successfully on Linux 4.19. With the patch as
posted, however, dax_pmem failed to probe it with -EINVAL and
/dev/dax0.0 was not created.

>=20
> I'm also wondering whether the initial range needs to satisfy
> memremap_compat_align(), or whether checking dev_dax->align is
> sufficient here.

Checking dev_dax->align is sufficient for a static Device DAX range.

For static Device DAX, libnvdimm supplies a pre-populated pgmap, and
nd_pfn_validate() already verifies that the start and end of the full
pgmap satisfy memremap_compat_align(). The dev_dax range is only the
usable data subset after the namespace metadata, so it only needs to
satisfy dev_dax->align.

Dynamic Device DAX is different because its pgmap is constructed
directly from the dev_dax ranges. Those ranges still need to satisfy
max(dev_dax->align, memremap_compat_align()).

>=20
> Have you also tested the static pmem Device DAX path, particularly
> with namespaces created by older kernels? The reproducer described
> in the cover letter addresses the alignment failure, but I'd like
> to make sure we aren't introducing a regression for existing
> namespaces.

Yes. After making the below change, I booted the same persistent
namespace created by Linux 4.19 without recreating it or modifying its
info block. It probed successfully, /dev/dax0.0 was restored, and it
retained its original 4K alignment and size.

I will include the following change in the next revision:

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 8616527656d8..5828ab334084 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -850,15 +850,23 @@ static int devm_register_dax_mapping(struct =
dev_dax *dev_dax, int range_id)

 static inline unsigned long dev_dax_min_align(struct dev_dax *dev_dax)
 {
+       /*
+        * A static device has a pre-populated pgmap whose range already
+        * satisfies memremap_compat_align(). Its data range may start =
after
+        * metadata at dev_dax->align granularity.
+        */
+       if (static_dev_dax(dev_dax))
+               return dev_dax->align;
+
+       /*
+        * The minimum mapping granularity for a dynamic device instance =
is a
+        * single subsection, unless the arch says otherwise.
+        */
        return max_t(unsigned long, dev_dax->align, =
memremap_compat_align());
 }

 static inline bool alloc_is_aligned(struct dev_dax *dev_dax, =
resource_size_t size)
 {
-       /*
-        * The minimum mapping granularity for a device instance is a
-        * single subsection, unless the arch says otherwise.
-        */
        return IS_ALIGNED(size, dev_dax_min_align(dev_dax));
 }

Thanks,
Muchun

>=20
> -- Alison
