Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D361A21A00AE6
 for <linux-nvdimm@lists.01.org>; Mon, 24 Sep 2018 14:02:15 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <153549644916.4089.12258485183075906901.stgit@djiang5-desk3.ch.intel.com>
References: <153549644916.4089.12258485183075906901.stgit@djiang5-desk3.ch.intel.com>
 <153549632073.4089.3609134467249378610.stgit@djiang5-desk3.ch.intel.com>
Subject: Re: [PATCH v8 02/12] libnvdimm: create keyring to store security keys
MIME-Version: 1.0
Content-ID: <29480.1537822932.1@warthog.procyon.org.uk>
Date: Mon, 24 Sep 2018 22:02:12 +0100
Message-ID: <29481.1537822932@warthog.procyon.org.uk>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Dave Jiang <dave.jiang@intel.com> wrote:

> +			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, &init_cred,

Hmmm...  I wonder if current_cred() would suffice since you must be called
from something that has the ability to load modules.  Further, I wonder if
module loading should be wrapped in an override with init_cred in the core.

> +			(KEY_USR_ALL & ~KEY_USR_SETATTR),

Did you really want to give the user write access, btw?

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
