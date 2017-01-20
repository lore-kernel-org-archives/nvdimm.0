From: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] xfs: test per-inode DAX flag by IO
Date: Fri, 20 Jan 2017 09:15:45 +0800
Message-ID: <20170120011545.eq72oj33467uigb5@XZHOUW.usersys.redhat.com>
References: <20170119055405.GT1859@eguan.usersys.redhat.com>
 <1484820838-5098-1-git-send-email-xzhou@redhat.com>
 <1484820838-5098-2-git-send-email-xzhou@redhat.com>
 <20170119204925.GB28456@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170119204925.GB28456-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Thu, Jan 19, 2017 at 01:49:25PM -0700, Ross Zwisler wrote:
> On Thu, Jan 19, 2017 at 06:13:57PM +0800, Xiong Zhou wrote:
...snip..
> > +	ret = munmap(map, len);
> > +	if (ret < 0)
> > +		err_exit("munmap", len, argv[4]);
> 
> Small nit: you munmap() to clean up the mmap(), but you don't close fd or fd2.

Thanks Ross and Eryu reviewing!

I'll send v3 of this patch shortly.

--
Xiong
