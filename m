Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 348D921CB74A7
 for <linux-nvdimm@lists.01.org>; Thu, 25 Oct 2018 03:04:12 -0700 (PDT)
Date: Thu, 25 Oct 2018 12:04:15 +0200
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] nfit, mce: only handle uncorrectable machine checks
Message-ID: <20181025100415.GB14020@nazgul.tnic>
References: <20181024200148.12597-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181024200148.12597-1-vishal.l.verma@intel.com>
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
Cc: linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Drop stable@ from CC.

On Wed, Oct 24, 2018 at 02:01:48PM -0600, Vishal Verma wrote:
> We only want a machine check error to be added to libnvdimm's 'badblock'
> if it was an uncorrectable error.

What is libnvdimm's 'badblock' ?

Also, pls write in the commit message *why* you want only UE errors.

Also, write your commit message in impartial tone, without the "we".

Thx.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
