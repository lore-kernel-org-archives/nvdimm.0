Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65DC7A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 07:11:02 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6DF5068AFE; Thu, 10 Mar 2022 08:10:59 +0100 (CET)
Date: Thu, 10 Mar 2022 08:10:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev, robert.hu@linux.intel.com,
	vishal.l.verma@intel.com, hch@lst.de, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/6] nvdimm/namespace: Delete nd_namespace_blk
Message-ID: <20220310071059.GD25138@lst.de>
References: <164688415599.2879318.17035042246954533659.stgit@dwillia2-desk3.amr.corp.intel.com> <164688417727.2879318.11691110761800109662.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164688417727.2879318.11691110761800109662.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 09, 2022 at 07:49:37PM -0800, Dan Williams wrote:
> Now that none of the configuration paths consider BLK namespaces, delete
> the BLK namespace data and supporting code.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
