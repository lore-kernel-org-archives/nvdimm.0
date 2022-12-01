Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AF110798
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 23:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16768C433C1;
	Thu,  1 Dec 2022 23:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1669936341;
	bh=edIThsRidex8fbJz68mBlOwb6JtXO7RHbQdCrilbD2A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XQoMqD7P287J4tXoAX4GpDndW13s1Jy7uwWEaF2I46mnhcrsyWrjUgI8PEYHsBEHD
	 3eo70ZQSoxt54NZHbf7vbW5TfHtkDLtQEbDjSnD2gtbhIB8QS8VbanAaAvDjFirG8q
	 4sR93Xngv9Ri8x6DgLZ7wWFiMNa8jKYHGDQHN+FM=
Date: Thu, 1 Dec 2022 15:12:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 "Jan Kara" <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>,
 "Christoph Hellwig" <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Felix Kuehling
 <Felix.Kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
 "Pan, Xinhui" <Xinhui.Pan@amd.com>, David Airlie <airlied@linux.ie>, Daniel
 Vetter <daniel@ffwll.ch>, Ben Skeggs <bskeggs@redhat.com>, Karol Herbst
 <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>, =?ISO-8859-1?Q?J=E9r?=
 =?ISO-8859-1?Q?=F4me?= Glisse <jglisse@redhat.com>, <linux-mm@kvack.org>,
 <dri-devel@lists.freedesktop.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] mm/memremap: Introduce pgmap_request_folio() using
 pgmap offsets
Message-Id: <20221201151220.10408e67b4949ea307492e79@linux-foundation.org>
In-Reply-To: <6387f3dabd16e_c95729461@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <166630293549.1017198.3833687373550679565.stgit@dwillia2-xfh.jf.intel.com>
	<Y1wgdp/uaoF70bmk@nvidia.com>
	<6387f3dabd16e_c95729461@dwillia2-mobl3.amr.corp.intel.com.notmuch>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 30 Nov 2022 16:22:50 -0800 Dan Williams <dan.j.williams@intel.com> wrote:

> I think since there is no urgent need for this series to move forward in
> v6.2 I can take the time to kill the need for pfn_to_pgmap_offset() and
> circle back for this in v6.3.

I'll drop v3 of "Fix the DAX-gup mistake" and "mm/memremap: Introduce
pgmap_request_folio() using pgmap offsets".

a) because Stephen says "no next-next material in next" and

b) because its presence in -next might invalidate testing of other
   things we have queued for the next merge window.



