Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM05-DM3-obe.outbound.protection.outlook.com
 (mail-eopbgr730128.outbound.protection.outlook.com [40.107.73.128])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 87AC721A02937
 for <linux-nvdimm@lists.01.org>; Wed, 13 Feb 2019 08:40:44 -0800 (PST)
Date: Wed, 13 Feb 2019 11:40:39 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: [LSF/MM TOPIC] Standardizing semantics around the per-file DAX flag
Message-ID: <20190213164039.GA16285@mit.edu>
MIME-Version: 1.0
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
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

There's been a long-term disagreement about how the per-file DAX flag
should work.

       * Should it exist at all?
       * What happens when the DAX flag is cleared?
           * Should it be not allowed and return an error?
	       (Or maybe only if the file is otherwise opened anywhere in the system?)
	   * Should it only takes effect when the file system is unmounted,
	     or when the inode drops out of the inode cache?
	* Should we remove the flag entirely and make it be something the
	  system automagically infers?

I had hoped consensus would be achieved before the ext4 per-file DAX
flag lands, but it hasn't for a *long* time.  Technically the DAX flag
is "experimental", which technically means it could be removed ---
although I suspect at this point, it would break some userspace, so
our options about how to adjust the semantics of the flag are probably
constrained.

						- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
