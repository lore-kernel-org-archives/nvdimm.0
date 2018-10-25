Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5DA2C2117B570
 for <linux-nvdimm@lists.01.org>; Thu, 25 Oct 2018 10:55:45 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] nfit, mce: only handle uncorrectable machine checks
Date: Thu, 25 Oct 2018 17:55:44 +0000
Message-ID: <c32b71a25704738b0e29612eb475a2ddf5cad3d8.camel@intel.com>
References: <20181024200148.12597-1-vishal.l.verma@intel.com>
 <20181025100415.GB14020@nazgul.tnic>
In-Reply-To: <20181025100415.GB14020@nazgul.tnic>
Content-Language: en-US
Content-ID: <339A6FD767CE3043BA3DA566CC7A7357@intel.com>
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
To: "bp@alien8.de" <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-10-25 at 12:04 +0200, Borislav Petkov wrote:
> Drop stable@ from CC.
> 
> On Wed, Oct 24, 2018 at 02:01:48PM -0600, Vishal Verma wrote:
> > We only want a machine check error to be added to libnvdimm's
> > 'badblock'
> > if it was an uncorrectable error.
> 
> What is libnvdimm's 'badblock' ?
> 
> Also, pls write in the commit message *why* you want only UE errors.
> 
> Also, write your commit message in impartial tone, without the "we".

Hi Borislav,

Thanks for the feedback, I'll send a new revision with better
explanations in the changelog.

Thanks,
	-Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
