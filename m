Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BCD2621A00AE6
 for <linux-nvdimm@lists.01.org>; Tue, 11 Sep 2018 09:34:30 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: open sets ext4_da_aops for DAX existing files
Date: Tue, 11 Sep 2018 16:34:03 +0000
Message-ID: <6d94d09e2539991db4853042b57bcf6274460f49.camel@hpe.com>
References: <76e07643e9c36e4273588bd3e7f29d1393de4c3d.camel@hpe.com>
 <20180910142902.GA30197@quack2.suse.cz>
 <0768c59f2d5391ff7678370fbc72cb664fca25fd.camel@hpe.com>
 <AT5PR8401MB1169A490CF0565CAD12ACC3DAB050@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <20180911152706.GG6104@quack2.suse.cz>
In-Reply-To: <20180911152706.GG6104@quack2.suse.cz>
Content-Language: en-US
Content-ID: <EF9168C114470C4999E461FCFD5DCE7F@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
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
To: "jack@suse.cz" <jack@suse.cz>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-09-11 at 17:27 +0200, Jan Kara wrote:
> On Mon 10-09-18 17:58:10, Elliott, Robert (Persistent Memory) wrote:
> > 
> > 
> > > -----Original Message-----
> > > From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of Kani, Toshi
> > > Sent: Monday, September 10, 2018 9:52 AM
> > > To: jack@suse.cz
> > > Cc: linux-fsdevel@vger.kernel.org; linux-nvdimm@lists.01.org
> > > Subject: Re: open sets ext4_da_aops for DAX existing files
> > 
> > ...
> > > > Good catch. Will you send a fix? I.e., call ext4_set_inode_flags() earlier
> > > > in the ext4_iget()? Did this bug have any user visible manifestations?
> > > 
> > > Yes, sync did not flush processor cache.
> > > 
> > > > Please also add:
> > > > 
> > > > Fixes: 5f0663bb4a64f588f0a2dd6d1be68d40f9af0086
> > > > 
> > > > so that stable automation picks this up. Thanks!
> > > > 
> > > 
> > > Will do.
> > > 
> > 
> > Also check if the same problem exists with ext2.
> 
> The problem also exists in ext2 so that needs fixing as well.

Right.  Once my ext4 patch 2/2 is reviewed, I will duplicate it for
ext2.

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
