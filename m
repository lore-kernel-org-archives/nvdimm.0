From: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>
Subject: RE: [PATCH 06/10] dax: provide an iomap based fault handler
Date: Sat, 10 Sep 2016 01:38:59 +0000
Message-ID: <DF4PR84MB0169843EFC69F8B00E19C9EFABFD0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1473438884-674-7-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org] On
> Behalf Of Christoph Hellwig
> Sent: Friday, September 09, 2016 11:35 AM
> Subject: [PATCH 06/10] dax: provide an iomap based fault handler
> 
...
> diff --git a/fs/dax.c b/fs/dax.c
> @@ -1343,4 +1343,117 @@ iomap_dax_rw(struct kiocb *iocb, struct
...
> +	default:
> +		WARN_ON_ONCE(1);
> +		error = -EIO;
> +	}
> +
> +	/* Filesystem should not return unwritten buffers to us! */
> +	error = dax_insert_mapping(mapping, iomap.bdev, sector, PAGE_SIZE,
> +			&entry, vma, vmf);

That -EIO value would be immediately overwritten.
