Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527FC28DD0
	for <nvdimm@lists.linux.dev>; Mon, 28 Jul 2025 08:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753692600; cv=none; b=lSF3v9STf0zh7EKIdy+ypreuh+ExQbmcP7nIDw0OMTCohUGcS9b4tyUEsDOkmM+A1Z/S+CXhhiP4cZluxV/wgKJ0RAYPj7/gDmwzNMjIRWppBeDZdkqFAl5YFqCnbWa/wPwY9I6oEEJLY4k2Ha1e+eEi+B/NF+OQr3SA9wUC1ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753692600; c=relaxed/simple;
	bh=TpJPGxKfvXvAjbAFEaZo7FdPosOGcKNZ9WkAuqWCWBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zi47UniSGorQFmYS3J+fT85ujdLkOLtFu/tgRIo7wpFAQfdv9I8LRDw8iSPRRP2NUHz/uz79BCVS9/w6rO8RLU9R3FnTIn6lUp3ZTjVjs9S5l0Czz/vXOMJZu/2eHTfjVjHRgLSsrc0KH3o4l5uhBe8SKKy6tNFoSSaD7cEhDcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jGblgL8f; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGblgL8f"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-612a338aed8so6568333a12.1
        for <nvdimm@lists.linux.dev>; Mon, 28 Jul 2025 01:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753692597; x=1754297397; darn=lists.linux.dev;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nsN7y/1kzG5yx277Iqzf5ufFB3MHq4CNNEmgUnJER1I=;
        b=jGblgL8fA2S7IrqGkHoZ8v6i6GLxhKdnesJXOsKCe8GL6JIDgqOwpJSpx+zqLpphSf
         hvLCcZNenlWWBBnytyfwSW+MUmG1/VQ7m6QWFbkLZbaqpBwpn1ZIUnQMF0b7DNQBALLA
         NMFMk86s99OQB21OQD3kNG8bSqT0DB314ayZkrvn9huT0OGqp+Ec/5W6aH5Jibtfhojy
         HDXox6OKKNObq0po/GtGftsiwLRwRLb3LVJ0rpdhlaEHvtFVzT1NvmeuHPGJa4O5aJfe
         uEHHnS5x8zGudaEZ6/x56MlbO/MLiKOI2+PczNX3CHvZs57HLsTt3IiQFfPxfQDd+e4v
         JJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753692597; x=1754297397;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nsN7y/1kzG5yx277Iqzf5ufFB3MHq4CNNEmgUnJER1I=;
        b=tL8fPcmVaGezE5JFtyO7aMdO3RdqW0sKcMMI4UACa3W/jyV5pq2nNQ+ILQA4tpmjnb
         rIwOCnEInC3/K0ZywBTRNelzTm0vCUssY7G8+CrqSyrUKEZy4Gz0p+LLa2fbDQAguv4i
         u2n5Mm4+VNMliim6NcyJSjkSOwK872lCY2XdJ2G3t3aCy/xZ1luspc3NImzmbJQjMq0X
         ZTG30Db4YPb6HHw6GKhL0zrZ8twoRBVvxqAZ/e6Hc6hlKJuVnAKuCRGFFv6FgKQdJZhU
         JGd3NqrwGDeFzYgkc8663ucM+F71vlyOaNK+LhAF2g3CisTHt/Gz+HlxZumTVBqiCdJn
         BbaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfhUdy/3dzhxge8/NgsxkSeOgqk7eiOTZ9MKi3zSBnQTJxyo1Zm2fG3BB2vtJAZk8qHXEedoQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPcbFILVbGv8S6LO0gE865se6m9x9b8LTYDh0A1lBdKMM8A8ju
	42zQovlfkjTCnGm5RUGGrMOsJA+FrfD/FfdsDKR7hS15/Z+KXViJ5hfO
X-Gm-Gg: ASbGncvCpgSJ5Gpq94SHREYF9ntD5VInI3EzcKmsgHFw6nOI1zcnJgeHBTT+yWPc8Cd
	UMKkRO5vy1TuhQ3pXm58E4UStVoiCYz4wryzVdeTZuI8HyBTJLkMK4D6n3oTl21Ajb1rFZ+KH6o
	GIUcEPVsHWGZzpVrqjF/IbX3Ra1KkYavrQ6CFyXXVjCNClxHRK6MxyH7OT2q9gQ/Gi7KiGmzzVS
	Aw1Tk/4bbaFCtteqEICuCIo98Rttew2DcPxgaBNxTjy2x0GrBGOe2e3hknxGkGuEVScM+Ey58xJ
	NnckQh5sqoSeAWVkqSzkvm6rdtnRvwgzhqI8IUl2DEoDOqlX62Ile81iRKNBWIWAlRD11VAtCgI
	Nv9qdYrWzvQqFSg0wgcU6jw==
X-Google-Smtp-Source: AGHT+IFaZJsTQLzzOiXfl1Nq1UVtUOTF8P3susmSPp5Bc8zyCjo/DGmP/Cxh+cs7YnmCiD5doe68aA==
X-Received: by 2002:a17:907:3e10:b0:ae0:d798:2ebd with SMTP id a640c23a62f3a-af61940ce29mr1071644666b.35.1753692596383;
        Mon, 28 Jul 2025 01:49:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af63589ff78sm394541266b.47.2025.07.28.01.49.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Jul 2025 01:49:55 -0700 (PDT)
Date: Mon, 28 Jul 2025 08:49:55 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 5/9] mm/huge_memory: mark PMD mappings of the huge
 zero folio special
Message-ID: <20250728084955.uzobxwoqalcuhk72@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-6-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717115212.1825089-6-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, Jul 17, 2025 at 01:52:08PM +0200, David Hildenbrand wrote:
>The huge zero folio is refcounted (+mapcounted -- is that a word?)
>differently than "normal" folios, similarly (but different) to the ordinary
>shared zeropage.
>
>For this reason, we special-case these pages in
>vm_normal_page*/vm_normal_folio*, and only allow selected callers to
>still use them (e.g., GUP can still take a reference on them).
>
>vm_normal_page_pmd() already filters out the huge zero folio. However,
>so far we are not marking it as special like we do with the ordinary
>shared zeropage. Let's mark it as special, so we can further refactor
>vm_normal_page_pmd() and vm_normal_page().
>
>While at it, update the doc regarding the shared zero folios.
>
>Reviewed-by: Oscar Salvador <osalvador@suse.de>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me
