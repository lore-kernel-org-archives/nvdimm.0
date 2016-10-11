Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Tue, 11 Oct 2016 14:33:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
Message-ID: <20161011183259.GA23193@localhost.localdomain>
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
 <dde78bbd-4739-98a1-4b69-2c2dff0a9d71@citrix.com>
 <57FCF26A02000078000F15E0@prv-mh.provo.novell.com>
 <CAPcyv4gD3JTq93ET0SAYOxyPO9c0RTkPKSQKqZLo_8KPn53TiA@mail.gmail.com>
 <20161011165811.GO19349@localhost.localdomain>
 <CAPcyv4jX_xzj=gz=tfoNMx0qFtyeKwqttzCE5GrOi6Kz5anhiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jX_xzj=gz=tfoNMx0qFtyeKwqttzCE5GrOi6Kz5anhiQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Juergen Gross <JGross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, Jan Beulich <jbeulich@suse.com>, andrew.cooper3@citrix.com, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 11, 2016 at 10:51:19AM -0700, Dan Williams wrote:
> 260sn3756f-1
> 	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
> 	for <konrad.wilk@oracle.com>; Tue, 11 Oct 2016 17:51:21 +0000
> Received: by mail-oi0-f43.google.com with SMTP id d132so32700570oib.2
>         for <konrad.wilk@oracle.com>; Tue, 11 Oct 2016 10:51:20 -0700 (PDT)
> DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
>         d=intel-com.20150623.gappssmtp.com; s=20150623;
>         h=mime-version:in-reply-to:references:from:date:message-id:subject:to
>          :cc;
>         bh=vXHG8Ke0lr+jk8ivMDq3ZpmmHHjC205aTSytpqjXFgo=;
>         b=CiKg4tJf1DGU2x/pSCYU7Jx79oCXMSIApwY2zJjO9Lny3erPxUyjNhszNyQkceYK1A
>          Gzuw05eETGT/k0UWamFdN/ZXF3PucSXIXqrVtTS9kLQBlKPTWQJvndSRqZ6lPb36mlSA
>          BrkdOREz5O/V7p/iGYhnxZU9eyfVY1ekgeMvTKP3su9Ye4Nk6GJYMEb5HSTCm1Ckmoq5
>          T4Rlw6gcnbHCLx27vcghySG4YXcQ4r2qSPcSmAysve77sYCPYlM9XRVpzfPBTmINKGUo
>          9w7MgVs5KG0dG60j1fJNjXoY0WSoP3uI67e69afqjAChzVndGDgMXjOzGrQ6+KQF088Q
>          JeiQ==
> X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
>         d=1e100.net; s=20130820;
>         h=x-gm-message-state:mime-version:in-reply-to:references:from:date
>          :message-id:subject:to:cc;
>         bh=vXHG8Ke0lr+jk8ivMDq3ZpmmHHjC205aTSytpqjXFgo=;
>         b=SmizBvFSmUHAy/WKfbD4m+QVSajIfcD9SQW7hwqmiwUtrACa2PxQWyx0dHe6DOqVVx
>          jYHSxbbMiz105BMwxfv2pZlAl+phFkj8APxpL2XF36SIsq5u9+evlqBUuzGcpVJ+tXyI
>          0xO0qfyspvNwLwJnkZ2bOxO9FM5cRhGGIAQ2uJCVIixLTPstJgkFL3taQ6bfr/epJGoF
>          VbYrGRu0nxGTWEqk14q0YBt2uiDLWu6WiF8izG/fnyM39wzS0ZsO31hco3jpBWiq7X5N
>          Ehn8ePiR9iYfowHhT3s2PefnrirD0zlJAamVqnbTNQS93PT26dWpm/vc8HVYiMLj+Fq8
>          s2rw==
> X-Gm-Message-State: AA6/9RlGCiscMzjRlXRLSGCPLACOp/VdD9I/y/dQ+vytyQN0tniPrwPxFp4VQtNbW/PYF1zzfyAX+iUOa+dgEsrg
> X-Received: by 10.202.84.69 with SMTP id i66mr3504473oib.93.1476208279931;
>  Tue, 11 Oct 2016 10:51:19 -0700 (PDT)
> MIME-Version: 1.0
> Received: by 10.157.39.201 with HTTP; Tue, 11 Oct 2016 10:51:19 -0700 (PDT)
> In-Reply-To: <20161011165811.GO19349@localhost.localdomain>
> References: <20161010003523.4423-1-haozhong.zhang@intel.com>
>  <dde78bbd-4739-98a1-4b69-2c2dff0a9d71@citrix.com> <57FCF26A02000078000F15E0@prv-mh.provo.novell.com>
>  <CAPcyv4gD3JTq93ET0SAYOxyPO9c0RTkPKSQKqZLo_8KPn53TiA@mail.gmail.com> <20161011165811.GO19349@localhost.localdomain>
> From: Dan Williams <dan.j.williams@intel.com>
> Date: Tue, 11 Oct 2016 10:51:19 -0700
> Message-ID: <CAPcyv4jX_xzj=gz=tfoNMx0qFtyeKwqttzCE5GrOi6Kz5anhiQ@mail.gmail.com>
> Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
> To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jan Beulich <jbeulich@suse.com>, Juergen Gross <JGross@suse.com>,
>         Haozhong Zhang <haozhong.zhang@intel.com>,
>         Xiao Guangrong <guangrong.xiao@linux.intel.com>,
>         Arnd Bergmann <arnd@arndb.de>,
>         "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
>         Boris Ostrovsky <boris.ostrovsky@oracle.com>,
>         andrew.cooper3@citrix.com,
>         "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
>         Stefano Stabellini <stefano@aporeto.com>,
>         David Vrabel <david.vrabel@citrix.com>,
>         Johannes Thumshirn <jthumshirn@suse.de>,
>         xen-devel@lists.xenproject.org,
>         Andrew Morton <akpm@linux-foundation.org>,
>         Ross Zwisler <ross.zwisler@linux.intel.com>
> Content-Type: text/plain; charset=UTF-8
> X-Source-IP: 209.85.218.43
> X-ServerName: mail-oi0-f43.google.com
> X-Proofpoint-SPF-Result: pass
> X-Proofpoint-SPF-Record: v=spf1 mx:intel.com include:_spf.google.com -all
> X-Proofpoint-Virus-Version: vendor=nai engine=5800 definitions=8315 signatures=670727
> X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1
>  malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
>  adjust=0 reason=mlx scancount=1 engine=8.0.1-1609300000
>  definitions=main-1610110304
> X-Spam: Clean
> 
> On Tue, Oct 11, 2016 at 9:58 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Tue, Oct 11, 2016 at 08:53:33AM -0700, Dan Williams wrote:
> >> On Tue, Oct 11, 2016 at 6:08 AM, Jan Beulich <jbeulich@suse.com> wrote:
> >> >>>> Andrew Cooper <andrew.cooper3@citrix.com> 10/10/16 6:44 PM >>>
> >> >>On 10/10/16 01:35, Haozhong Zhang wrote:
> >> >>> Xen hypervisor needs assistance from Dom0 Linux kernel for following tasks:
> >> >>> 1) Reserve an area on NVDIMM devices for Xen hypervisor to place
> >> >>>    memory management data structures, i.e. frame table and M2P table.
> >> >>> 2) Report SPA ranges of NVDIMM devices and the reserved area to Xen
> >> >>>    hypervisor.
> >> >>
> >> >>However, I can't see any justification for 1).  Dom0 should not be
> >> >>involved in Xen's management of its own frame table and m2p.  The mfns
> >> >>making up the pmem/pblk regions should be treated just like any other
> >> >>MMIO regions, and be handed wholesale to dom0 by default.
> >> >
> >> > That precludes the use as RAM extension, and I thought earlier rounds of
> >> > discussion had got everyone in agreement that at least for the pmem case
> >> > we will need some control data in Xen.
> >>
> >> The missing piece for me is why this reservation for control data
> >> needs to be done in the libnvdimm core?  I would expect that any dax
> >
> > Isn't it done this way with Linux? That is say if the machine has
> > 4GB of RAM and the NVDIMM is in TB range. You want to put the 'struct page'
> > for the NVDIMM ranges somewhere. That place can be in regions on the
> > NVDIMM that ndctl can reserve.
> 
> Yes.
> 
> >> capable file could be mapped and made available to a guest.  This
> >> includes /dev/ramX devices that are dax capable, but are external to
> >> the libnvdimm sub-system.
> >
> > This is more of just keeping track of the ranges if say the DAX file is
> > extremely fragmented and requires a lot of 'struct pages' to keep track of
> > when stiching up the VMA.
> 
> Right, but why does the libnvdimm core need to know about this
> specific Xen reservation?  For example, if Xen wants some in-kernel

Let me turn this around - why does the libnvdimm core need to know about
Linux specific parts? Shouldn't this be OS agnostic, so that FreeBSD
for example can also poke a hole in this and fill it with its
OS-management meta-data?

> driver to own a pmem region and place its own metadata on the device I
> would recommend something like:
> 
>     bdev = blkdev_get_by_path("/dev/pmemX",  FMODE_EXCL...);
>     bdev_direct_access(bdev, ...);
> 
> ...in other words, I don't think we want libnvdimm to grow new device
> types for every possible in-kernel user, Xen, MD, DM, etc. Instead,
> just claim the resulting device.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
