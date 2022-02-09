Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F004B2F21
	for <nvdimm@lists.linux.dev>; Wed,  9 Feb 2022 06:22:31 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id C6D0E68AFE; Wed,  9 Feb 2022 07:22:26 +0100 (CET)
Date: Wed, 9 Feb 2022 07:22:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Ben Skeggs <bskeggs@redhat.com>,
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Alistair Popple <apopple@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	amd-gfx list <amd-gfx@lists.freedesktop.org>,
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
	nouveau@lists.freedesktop.org,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH 6/8] mm: don't include <linux/memremap.h> in
 <linux/mm.h>
Message-ID: <20220209062226.GA7739@lst.de>
References: <20220207063249.1833066-1-hch@lst.de> <20220207063249.1833066-7-hch@lst.de> <CAPcyv4iYfnJN+5=0Gzw8gKpNCG3PJS1MEZxxoPwuojhU6XHNRA@mail.gmail.com> <CAPcyv4jfNa2BBuE7E0+8LO5VT9APS1eF3c4Rw99oKY6y+1re9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4jfNa2BBuE7E0+8LO5VT9APS1eF3c4Rw99oKY6y+1re9w@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 08, 2022 at 03:53:14PM -0800, Dan Williams wrote:
> Yeah, same as Logan:
> 
> mm/memcontrol.c: In function ‘get_mctgt_type’:
> mm/memcontrol.c:5724:29: error: implicit declaration of function
> ‘is_device_private_page’; did you mean
> ‘is_device_private_entry’? [-Werror=implicit-function-declaration]
>  5724 |                         if (is_device_private_page(page))
>       |                             ^~~~~~~~~~~~~~~~~~~~~~
>       |                             is_device_private_entry
> 
> ...needs:

Yeah, the buildbot also complained.  I've fixed this up locally now.
