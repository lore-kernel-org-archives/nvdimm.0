Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8A768
	for <nvdimm@lists.linux.dev>; Fri, 19 Nov 2021 06:55:07 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id BAD8C68AFE; Fri, 19 Nov 2021 07:54:57 +0100 (CET)
Date: Fri, 19 Nov 2021 07:54:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-erofs@lists.ozlabs.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 02/29] dm: make the DAX support dependend on
 CONFIG_FS_DAX
Message-ID: <20211119065457.GA15524@lst.de>
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-3-hch@lst.de> <CAPcyv4iPOcD8OsimpSZMnbTEsGZKj-GqSY=cWC0tPvoVs6DE1Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iPOcD8OsimpSZMnbTEsGZKj-GqSY=cWC0tPvoVs6DE1Q@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 17, 2021 at 09:23:44AM -0800, Dan Williams wrote:
> Applied, fixed the spelling of 'dependent' in the subject and picked
> up Mike's Ack from the previous send:
> 
> https://lore.kernel.org/r/YYASBVuorCedsnRL@redhat.com
> 
> Christoph, any particular reason you did not pick up the tags from the
> last posting?

I thought I did, but apparently I've missed some.
