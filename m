Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2371F2034CF96
 for <linux-nvdimm@lists.01.org>; Mon, 30 Oct 2017 09:41:27 -0700 (PDT)
Subject: Re: [bug report] libnvdimm: add support for clear poison list and
 badblocks for device dax
References: <20171026112012.7k32soimjpv5nk5f@mwanda>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <ee6919fa-5a41-ded6-3790-edf3e58ba44f@intel.com>
Date: Mon, 30 Oct 2017 09:45:17 -0700
MIME-Version: 1.0
In-Reply-To: <20171026112012.7k32soimjpv5nk5f@mwanda>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 10/26/2017 04:20 AM, Dan Carpenter wrote:
> Hello Dave Jiang,
> 
> The patch 006358b35c73: "libnvdimm: add support for clear poison list
> and badblocks for device dax" from Apr 7, 2017, leads to the
> following static checker warning:
> 
> 	drivers/nvdimm/bus.c:852 nd_pmem_forget_poison_check()
> 	warn: we tested 'nd_dax' before and it was 'false'

Thanks Dan. I'll remove unused code.

> 
> drivers/nvdimm/bus.c
>    835  static int nd_pmem_forget_poison_check(struct device *dev, void *data)
>    836  {
>    837          struct nd_cmd_clear_error *clear_err =
>    838                  (struct nd_cmd_clear_error *)data;
>    839          struct nd_btt *nd_btt = is_nd_btt(dev) ? to_nd_btt(dev) : NULL;
>    840          struct nd_pfn *nd_pfn = is_nd_pfn(dev) ? to_nd_pfn(dev) : NULL;
>    841          struct nd_dax *nd_dax = is_nd_dax(dev) ? to_nd_dax(dev) : NULL;
>                                ^^^^^^
> nd_dax is set here.
> 
>    842          struct nd_namespace_common *ndns = NULL;
>    843          struct nd_namespace_io *nsio;
>    844          resource_size_t offset = 0, end_trunc = 0, start, end, pstart, pend;
>    845  
>    846          if (nd_dax || !dev->driver)
>                     ^^^^^^
> We return if it's non-NULL
> 
>    847                  return 0;
>    848  
>    849          start = clear_err->address;
>    850          end = clear_err->address + clear_err->cleared - 1;
>    851  
>    852          if (nd_btt || nd_pfn || nd_dax) {
>    853                  if (nd_btt)
>    854                          ndns = nd_btt->ndns;
>    855                  else if (nd_pfn)
>    856                          ndns = nd_pfn->ndns;
>    857                  else if (nd_dax)
>                                  ^^^^^^
> but the rest of the function assumes it can be true.  Perhaps we plan
> to enable it in the future?  It's not clear to me.
> 
>    858                          ndns = nd_dax->nd_pfn.ndns;
>    859  
>    860                  if (!ndns)
>    861                          return 0;
>    862          } else
>    863                  ndns = to_ndns(dev);
>    864  
>    865          nsio = to_nd_namespace_io(&ndns->dev);
>    866          pstart = nsio->res.start + offset;
>    867          pend = nsio->res.end - end_trunc;
>    868  
>    869          if ((pstart >= start) && (pend <= end))
>    870                  return -EBUSY;
>    871  
>    872          return 0;
>    873  
>    874  }
> 
> regards,
> dan carpenter
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
