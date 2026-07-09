Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90657366DA5
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 15:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783610331; cv=none; b=nNPRNn1gXVC9SU76SXZQGjarZoZ/I/soy81lxgmDE5n98tylfKEC4jv71K9zJYNSkfH1CSmmoZVx2bjpXbbijZ72faRzN/06Dy/ItX3GLYszpZSg1vA9j8YN7sojFdOWU8EzbvmmoOKPMQJNorm73w2RZLox2dhZ8m0Ju4ulfng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783610331; c=relaxed/simple;
	bh=EmhDmZEzfDqtz+/wM5OYtSnBNKhNR5z6WmgKAnKqYZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b6IRr/hWaJZww+koLV4wsba0EcYhIoGXliS7LHHfdt2Xql6/VHGqPxC2ZkQ6Xq3xQRIxNjCi0ngb1fCcMB08phLiXfTrJ/2Qt8f59T19jRSyjXvMbTkrzdBPxuZxKdj2gS8mbg/yO9Tvpm+ogZeOxyelSslOo1XO4YJDp+711Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=uSvqpOMo; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="uSvqpOMo"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c16ac21acso11053951cf.0
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 08:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783610327; x=1784215127; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D66HPeIJnm5ZDnK+VorUOpyiniaZPeUCt2fPIKMnyb4=;
        b=uSvqpOMofbgdRq/a0RhxSezI+9d0hrh4xRP1dXAY+GmKUHW0yjdQild8x4YHHJBm1k
         jVVzNtkz7/htkn6SXgtS/QkgGn/Qny3KsRrx9vdGdiR7MJiEM2E01bnSMwlQ4B6g2HNa
         0YQHPLKgfZ4laBnFG1aZur/Nu6GQL1umPB5E6UoDWXnOFeWx9hH2TU5F+Zp2HsBFikHX
         pePgu9Ggy8eGxN+LWBUAmIb9W7yMR6C9s6YbnTO7Nx+NZg1cg7S/kYolClSngAu3l56E
         +wXxjOdk/K/GJXDLz7VzBMfnZO+d5FmxbN2Biu6UV9SPpEyv5TgIeiZ96Nrbao/ySFM4
         P+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783610327; x=1784215127;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D66HPeIJnm5ZDnK+VorUOpyiniaZPeUCt2fPIKMnyb4=;
        b=CScGRKmIPtSNsqMPTFOUi26qWfvY5dW4PMRmTzC+lZICj69IiqU+SALwZFVnOqiUJ2
         2ymuUwte6aIMTgoJcrMNpdZod7a0bdH7aYgNIMz4ZxmxM8JhDsNwjKBy3bUVU2G+WNjH
         xW7X5yWr6ulSbNuuAyT7gCFtT0Jp/k44+IOO+nYjIbvr1gXwJMNKHcDRfhNYl+bdFzGm
         nRQcddax4MK8LrvtsR1pVwGd+hiRNKhwIZ5B7NrDNdJnw/Rgd+uTJj46CbiydgG0cACt
         RZft8cgH1C5JnVsuK8ZwM2sidvURwiESzGmomilBd1sBVhmOKjcvaRjjsPKqp45vV+eI
         3L6A==
X-Forwarded-Encrypted: i=1; AHgh+Ro52NfS649shEUfzyV90qHh0a7wb6C2iyF6RF+Oz3B9UHEm4yxh9h+7HJYYmv7SaMeqfntrLN0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOLhjDKGz8mukuAs818xXANjm9R1bBGqIO317yEAal5A/NrdGi
	cUPayHmaPdVM6bAzcMKN93stA+IPWVfga/VjYG3BqJnLxzlicdDR+o6xNwU3mvsFA2Q=
X-Gm-Gg: AfdE7ckiKZllMWPUbJInWT+IfiuRufKilym08/mTk/wa1sFp32vRlcU1xX3qN2nrQpJ
	3f7Z88W1lp3ImsddiqX6nOFPQYX6xCcMkkBfXYRpsH+QKa8iUCR8tpKkyn1U1YK0xSI9jDrXeb5
	Bgkn1YjrufDhdzIlF7iyisvdiXBC6/tTrTKTvrSF46rgJ3sSYdB8JLWRDhMc/2Ic5oxkghvEHT4
	nRHXCEY309f74ZwCw0yL1jQDo0DfQk0bsKncbVIusjrAZMlIPlrcBf+o8cvkatVHg+kDUPwf4O8
	HzcdASpUkl1D0Y/Z280vt+2crV5hCXAcvIT62emplgaF+72+Ijz6YP+u+R1d+usSAo8nPObH0S0
	cMiHZD7QuNLe2tOatrSZGSPv5QHAD0POZnEF1qGdizUFf2bgaM6b2t6Lo6croZHr1j9Cdr5Puuc
	g62wsAWnd9GtAec6reGrUnHtn61QG0Nd/v0fA7vIrjtZBt1+ZSf3NEgSA039bNiNCUX8+22OTg4
	BA+5K8=
X-Received: by 2002:ac8:5cd4:0:b0:51c:1c2c:a8c9 with SMTP id d75a77b69052e-51c8b3e2e32mr79753441cf.43.1783610327278;
        Thu, 09 Jul 2026 08:18:47 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c41db4fb5sm158006781cf.25.2026.07.09.08.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:18:45 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:18:40 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 13/30] mm/vma: refactor vmg_adjust_set_range() for clarity
Message-ID: <ak-70CHGujkI5jJI@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <ada7972f49ea7f1ff1df6d11e4651f270444f8fd.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada7972f49ea7f1ff1df6d11e4651f270444f8fd.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:24PM +0100, Lorenzo Stoakes wrote:
> Add comments with ASCII diagrams to describe what we're doing, avoid
> dubious use of PHYS_PFN(), and use vma_start_pgoff().
> 
> The most complicated scenario represented here is vmg->__adjust_next_start
> - when this is set, vmg->[start, end] actually indicate the range to be
> retained, so take special care to describe this accurately.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

> +		/*
> +		 * vmg->start    vmg->end
> +		 * |             |
> +		 * v    merge    v
> +		 * <------------->
> +		 *         delta
> +		 *        <------>
> +		 * |------|----------------|
> +		 * | prev |    middle      |
> +		 * |------|----------------|
> +		 *        ^
> +		 *        |
> +		 *        middle->vm_start
> +		 */

Even with these diagrams, it's a bit difficult to understand what the
actual intent/result of this chunk is (but that may be a limitation of
me not spending enough time reading the surrounding code, not a comment
of your work here).

~Gregory

> +		/*
> +		 *                Originally:
> +		 *
> +		 *            vmg->start   vmg->end
> +		 *            |            |
> +		 *            v    merge   v
> +		 *            <------------>
> +		 *            .            .
> +		 * merge_existing_range() updates to:
> +		 *            .            .
> +		 * vmg->start vmg->end     .
> +		 * |          |            .
> +		 * v  retain  v            .
> +		 * <---------->            .
> +		 *             delta       .
> +		 *            <----->      .
> +		 * |----------------|------|
> +		 * |    middle      | next |
> +		 * |----------------|------|
> +		 *                  ^
> +		 *                  |
> +		 *                  next->vm_start
> +		 */
