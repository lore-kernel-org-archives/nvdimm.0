Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 53E0881E10
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jan 2017 02:16:46 -0800 (PST)
Date: Wed, 18 Jan 2017 11:16:41 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Badblocks checking/representation in
 filesystems
Message-ID: <20170118101641.GD24789@quack2.suse.cz>
References: <at1mp6pou4lenesjdgh22k4p.1484345585589@email.android.com>
 <b9rbflutjt10mb4ofherta8j.1484345610771@email.android.com>
 <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170114004910.GA4880@omniknight.lm.intel.com>
 <SN2PR04MB2191A6EDB7203AF86600FD25887D0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170117143703.GP2517@quack2.suse.cz>
 <20170117221421.GC4880@omniknight.lm.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170117221421.GC4880@omniknight.lm.intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Jan Kara <jack@suse.cz>, Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Viacheslav Dubeyko <slava@dubeyko.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 17-01-17 15:14:21, Vishal Verma wrote:
> Your note on the online repair does raise another tangentially related
> topic. Currently, if there are badblocks, writes via the bio submission
> path will clear the error (if the hardware is able to remap the bad
> locations). However, if the filesystem is mounted eith DAX, even
> non-mmap operations - read() and write() will go through the dax paths
> (dax_do_io()). We haven't found a good/agreeable way to perform
> error-clearing in this case. So currently, if a dax mounted filesystem
> has badblocks, the only way to clear those badblocks is to mount it
> without DAX, and overwrite/zero the bad locations. This is a pretty
> terrible user experience, and I'm hoping this can be solved in a better
> way.

Please remind me, what is the problem with DAX code doing necessary work to
clear the error when it gets EIO from memcpy on write?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
