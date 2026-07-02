Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD27B2C21F2;
	Thu,  2 Jul 2026 10:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989479; cv=none; b=opVF5yXpxRPtLNlWBc7tAY67kd7vMnheOU5fSdD75CKgiVpN4DMnRT1DnWM/2AjED3rDUytUI3AyhFT/blGIjM7KdxSiIIwyrPPRkCa2yGuo2KTq90GltMjbGxdKMTpfHSk35C2/c1qqkECzk9JXbipP2pJLG/4/q+Kmi/nhFp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989479; c=relaxed/simple;
	bh=0Qn1ltllIXRw/FAGQooEHN6VeKOdm3O1QgQ7rdBQX2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxUm3bde2q3dmk9td6Vhvjs9Vq2emiRoYA4HhWLQLoMFfgKlamPMG+7RNGbPbiRgodybNEzXZddqRrR75sqq8PQMyZhUCP3HBCT0KlUTaLyXkHgHxUJ9Uz3nGfNQK2FIcDTIpygFKNHIvkuk2i6CL2rAlfb9nyIdesWypvX8nXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqfDPRoQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqfDPRoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A432F1F000E9;
	Thu,  2 Jul 2026 10:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782989478;
	bh=prNepFwbbNENFK8ZoSoOyJUpCn4wZi4Ts2NMaeAqiMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UqfDPRoQYK8ANeU4JUCLjKk9A8iE+hSWZ5wo1NqICXJ2dLmh73t4GqMO1fh0HAn1K
	 pwTV7GYSa5WUr2DuNxzAidH757fbi4hkBVfhORzKkMPouaGSMTC3eC7P64pygPx1gg
	 twzR4BS+XJmtcXGhnBk6IOBVH5lML7tYmNSrdqjQkghoHAUdY2a9K3BbGlsRvEzP8z
	 qiRubXQIvMiYJo9cyIPjaUHLYRsw4Q780Fqe6cunRrITc9+NUlbI4WXrJrMsbc/go/
	 0sJrEx4V4K3K4d+AIMG568tIZ3hxQUlIFCj6BKr8thGyIdR+Mq7VpaUHu2vgSQvE3H
	 pIcYBXUjIpU7A==
Date: Thu, 2 Jul 2026 11:50:56 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 13/30] mm/vma: refactor vmg_adjust_set_range() for clarity
Message-ID: <akZCV83FL8hW2O-Y@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <ada7972f49ea7f1ff1df6d11e4651f270444f8fd.1782735110.git.ljs@kernel.org>
 <akY-Z1fsp9rHSc70@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akY-Z1fsp9rHSc70@pedro-suse.lan>

On Thu, Jul 02, 2026 at 11:37:11AM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:24PM +0100, Lorenzo Stoakes wrote:
> > Add comments with ASCII diagrams to describe what we're doing, avoid
> > dubious use of PHYS_PFN(), and use vma_start_pgoff().
> >
> > The most complicated scenario represented here is vmg->__adjust_next_start
> > - when this is set, vmg->[start, end] actually indicate the range to be
> > retained, so take special care to describe this accurately.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  mm/vma.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 47 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 6296acecf3b7..1e99fe8aa6ef 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -704,11 +704,54 @@ static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
> >  	pgoff_t pgoff;
> >
> >  	if (vmg->__adjust_middle_start) {
> > -		adjust = vmg->middle;
> > -		pgoff = adjust->vm_pgoff + PHYS_PFN(vmg->end - adjust->vm_start);
> > +		/*
> > +		 * vmg->start    vmg->end
> > +		 * |             |
> > +		 * v    merge    v
> > +		 * <------------->
> > +		 *         delta
> > +		 *        <------>
> > +		 * |------|----------------|
> > +		 * | prev |    middle      |
> > +		 * |------|----------------|
> > +		 *        ^
> > +		 *        |
> > +		 *        middle->vm_start
> > +		 */
> > +		struct vm_area_struct *middle = vmg->middle;
>
> FWIW this can be simplified to
> 		adjust = middle;
> 		const unsigned long delta = vmg->end - adjust->vm_start;
>
> But I guess you're looking for explicitness here?

Yeah I'm intentionally trying to make that explicit as this code is very
confusing, so people don't have to think 'oh what was adjust again?'.

>
> > +		const unsigned long delta = vmg->end - middle->vm_start;
> > +
> > +		pgoff = vma_start_pgoff(middle) + (delta >> PAGE_SHIFT);
> > +		adjust = middle;
> >  	} else if (vmg->__adjust_next_start) {
> > -		adjust = vmg->next;
> > -		pgoff = adjust->vm_pgoff - PHYS_PFN(adjust->vm_start - vmg->end);
> > +		/*
> > +		 *                Originally:
> > +		 *
> > +		 *            vmg->start   vmg->end
> > +		 *            |            |
> > +		 *            v    merge   v
> > +		 *            <------------>
> > +		 *            .            .
> > +		 * merge_existing_range() updates to:
> > +		 *            .            .
> > +		 * vmg->start vmg->end     .
> > +		 * |          |            .
> > +		 * v  retain  v            .
> > +		 * <---------->            .
> > +		 *             delta       .
> > +		 *            <----->      .
> > +		 * |----------------|------|
> > +		 * |    middle      | next |
> > +		 * |----------------|------|
> > +		 *                  ^
> > +		 *                  |
> > +		 *                  next->vm_start
> > +		 */
> > +		struct vm_area_struct *next = vmg->next;
> > +		const unsigned long delta = next->vm_start - vmg->end;
> > +
> > +		pgoff = vma_start_pgoff(next) - (delta >> PAGE_SHIFT);
> > +		adjust = next;
> >  	} else {
> >  		return;
> >  	}
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

>
> --
> Pedro

Cheers, Lorenzo
