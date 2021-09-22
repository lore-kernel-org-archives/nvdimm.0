Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9476F3FC8
	for <nvdimm@lists.linux.dev>; Wed, 22 Sep 2021 18:33:22 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id E535E67373; Wed, 22 Sep 2021 20:33:13 +0200 (CEST)
Date: Wed, 22 Sep 2021 20:33:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: dax_supported() related cleanups v2
Message-ID: <20210922183313.GA24528@lst.de>
References: <20210922173431.2454024-1-hch@lst.de> <CAPcyv4jpTyzofDyUPi7ADbGcV+cJHSohctwxu5yDNTF34KWeOg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jpTyzofDyUPi7ADbGcV+cJHSohctwxu5yDNTF34KWeOg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 22, 2021 at 10:55:01AM -0700, Dan Williams wrote:
> This looks like your send script picked up the wrong cover letter?

Yes.  Or the human running the script to be exact :)
