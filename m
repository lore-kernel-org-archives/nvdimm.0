Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2001:1868:205::9])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 42A1081787
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jan 2017 07:08:13 -0800 (PST)
Date: Tue, 17 Jan 2017 07:08:09 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Badblocks checking/representation in
 filesystems
Message-ID: <20170117150809.GA12484@infradead.org>
References: <at1mp6pou4lenesjdgh22k4p.1484345585589@email.android.com>
 <b9rbflutjt10mb4ofherta8j.1484345610771@email.android.com>
 <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170114004910.GA4880@omniknight.lm.intel.com>
 <SN2PR04MB2191A6EDB7203AF86600FD25887D0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170117143703.GP2517@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170117143703.GP2517@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Viacheslav Dubeyko <slava@dubeyko.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 17, 2017 at 03:37:03PM +0100, Jan Kara wrote:
> Well, the situation with NVM is more like with DRAM AFAIU. It is quite
> reliable but given the size the probability *some* cell has degraded is
> quite high. And similar to DRAM you'll get MCE (Machine Check Exception)
> when you try to read such cell. As Vishal wrote, the hardware does some
> background scrubbing and relocates stuff early if needed but nothing is 100%.

Based on publically available papers and little information leaks
there is no persistent NVM that comes even close to the error rate
for DRAM - they all appear to be magnitudes worse.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
