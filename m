Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3CDA41A1E04
 for <linux-nvdimm@lists.01.org>; Thu, 23 Jun 2016 03:48:02 -0700 (PDT)
Date: Thu, 23 Jun 2016 12:47:28 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] dax: Clear dirty entry tags on cache flush
Message-ID: <20160623104728.GA25982@quack2.suse.cz>
References: <1466523915-14644-1-git-send-email-jack@suse.cz>
 <1466523915-14644-4-git-send-email-jack@suse.cz>
MIME-Version: 1.0
In-Reply-To: <1466523915-14644-4-git-send-email-jack@suse.cz>
Content-Disposition: inline
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
To: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Hi,

the previous version had a bug which manifested itself on i586. Attached is
a new version for the patch if someone is interested.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
