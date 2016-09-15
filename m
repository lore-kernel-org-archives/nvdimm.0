From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 06/12] dax: provide an iomap based fault handler
Date: Thu, 15 Sep 2016 07:13:14 +0200
Message-ID: <20160915051314.GE6188@lst.de>
References: <1473847291-18913-1-git-send-email-hch@lst.de>
 <1473847291-18913-7-git-send-email-hch@lst.de>
 <20160914172717.GB30852@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160914172717.GB30852-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 14, 2016 at 11:27:17AM -0600, Ross Zwisler wrote:
> > +	case IOMAP_UNWRITTEN:
> > +	case IOMAP_HOLE:
> > +		if (!(vmf->flags & FAULT_FLAG_WRITE))
> > +			return dax_load_hole(mapping, entry, vmf);
> > +		/*FALLTHU*/
> 
> 		  FALLTHRU

Ooops, yes.

> 
> > +	default:
> > +		WARN_ON_ONCE(1);
> > +		error = -EIO;
> > +		break;
> 
> No need to break here.

Not really needed, but definitively more future-proof..
