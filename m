Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0063F9C5
	for <nvdimm@lists.linux.dev>; Fri, 25 Jul 2025 02:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753411654; cv=none; b=AtJfvjuSsIrKBsruQrWx8n0LrNhrnnh6tFavYqZfzAo+ba7MiwhBMVMfbwo0/7QrE2O0TQR9eihpvIy6m67beSugpe3B/phFYntVGcpZu14szeOWpalW/gtu15PyS77FY15Y3TfTl/+VqkJQZYHkOpdW+uUMu4pF82z3ObymB7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753411654; c=relaxed/simple;
	bh=rdizep0zrpfkZKg0NfdnQ/QLu8dJHEerhVlSIUnwf+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UeQQXkjgKaeNSOn/+pafzVsQQhfqtUltxT23Q7u6Tf6sxvhdmcwcJ7lgzdQXKEGvDOpYL7TCTy3O56e5nL6a1KFLIz/swpmkpr0DtFug4V0LATeLzuqxH8auLBxpJ6MDESSFXfbJmYukdc3sQjsLT2liiG8Kz/fOX0awuBCj2yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IYi0cNLY; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IYi0cNLY"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-60c6fea6742so3348193a12.1
        for <nvdimm@lists.linux.dev>; Thu, 24 Jul 2025 19:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753411651; x=1754016451; darn=lists.linux.dev;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xc3hDEGPGsCDebYX51sWpA/bxBMOB24GoB4P11DkIaw=;
        b=IYi0cNLYjpZ0UEXPfCs3ttFIz4MRBPJ/gX6ovCsX0gZ9GJs/nU3sufHovQMSY5eI4Z
         Elg2TXvXysIBBYrTrXszxUag8OGg6UN3fTOO6fhHTCyx10RDJUfiGX220djM/aHI8lvz
         ddZEuUlB/4+4KVfdzgq9tpOKbDUWqojTb70yGgPkWPx5khYKqR37zk9em04V5Z07EUz7
         coGevirEY5/aiXpNMwLwqmY+MKLVtyc1hF+65qvHS74I5PqPUrH/ajeaUyD1QdUQHQKh
         DgZl1z1hk0n099w75CSEClYVdUkYZJjQfzS+XcQX9Oxl3YhMspLvHOMxwh3I2IQJfW6s
         5zNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753411651; x=1754016451;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xc3hDEGPGsCDebYX51sWpA/bxBMOB24GoB4P11DkIaw=;
        b=dBchzkOSPPTxwvc9fdmwuDqkh7R0pSgx/wF0B0aCGvDHvsLFkQ5Iri1K8uPDpxN9DW
         b6XA5A0BOQudGzBxcN4jDpHTbT+LEslFIj6ByZfrsBLguBP+pPtkUnxedQfRJu9DEqDA
         CHCUBQgNB8ykK4AJIF6UIBpWwOpTTKlrmYVlHa4YzHjTicPvrlabsG2uhjMyVxXde9xq
         C+up0Ig1Z4fipeVUU2abvua906xKME5b1M+ID8xtnTt+o9NgyQmIK71YWlGbVsNrjabp
         A8StHT8Y1Z2916Eu9s3p8CazPJxBIa3M9GhqVjHiMoza1owLMQyxANfjTY1RiBCKk7kY
         68EQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3gAmBTq1uc5q+CJ1Fjneq2ynwjQUUoIEHh0EviaRD9tfTad+JuXDcrQM1oGbU3vU+xRLBI6g=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1bmNBoZbeC7e5X0vig2UTgSYkqoDeQe7fDwgZZy854BWBOwWs
	tLVko9WFM1FXFAoHFfurJAfJKek8qfoCdTeYk8XM1ffoCCHM4l+cJq6z
X-Gm-Gg: ASbGncvqEcup03/kXZpVfGR4co7WlEYGIUvtHHWRoudCyCRPNTQSHXyiMg3QIips4bS
	4vX6sEn1bBWqNXBjX55oDBoGKn+O+vmtSctaGIA6ziF6+Jw4/Jw+N1mQ/U02AAIrXHQcw3XBv3F
	E0qFNyaX1fFRArxgwZYZ8RBXu22T/OzaatlRSjAT3lOeStoHTtRGfYXZjnoa0Yl3D1uiyxirEBR
	hc7mYd2wnNqRGRhsSuQam+JWDO494/fbEEhi/Hy3qRevEUI/CarbtDVmyVWnztnjyK+vgX/W81s
	owNALUBjfqBrbkjyKjadXzyY26B67PsnkYiqaihjDqFAF7w/uv/y/FqlWU5xFgTcuUm7j9uf5Pl
	qrUe+c2iKQyKkhUIItBR0Rg==
X-Google-Smtp-Source: AGHT+IHalRLNdYC73lbRRqlIizE8OiCJMhgGy8d4kUNVhjNjBAndWdZO49wygHZRXIZ+3UwJxXytHQ==
X-Received: by 2002:a17:906:f596:b0:ae0:d4f2:dff3 with SMTP id a640c23a62f3a-af619b04c91mr39263566b.58.1753411650558;
        Thu, 24 Jul 2025 19:47:30 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af47ff42ce6sm195436866b.129.2025.07.24.19.47.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jul 2025 19:47:30 -0700 (PDT)
Date: Fri, 25 Jul 2025 02:47:29 +0000
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
	Lance Yang <lance.yang@linux.dev>,
	Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH v2 1/9] mm/huge_memory: move more common code into
 insert_pmd()
Message-ID: <20250725024729.emodbzsflthdzyzh@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-2-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717115212.1825089-2-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, Jul 17, 2025 at 01:52:04PM +0200, David Hildenbrand wrote:
>Let's clean it all further up.
>
>No functional change intended.
>
>Reviewed-by: Oscar Salvador <osalvador@suse.de>
>Reviewed-by: Alistair Popple <apopple@nvidia.com>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me
