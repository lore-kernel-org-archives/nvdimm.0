Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 921CF20968915
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 04:17:21 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5959.1531910449@warthog.procyon.org.uk>
References: <5959.1531910449@warthog.procyon.org.uk>
 <153186087257.27463.13382652631526471099.stgit@djiang5-desk3.ch.intel.com>
 <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
Subject: Re: [PATCH v5 05/12] keys: add call key_put_sync() to flush
 key_gc_work when doing a key_put().
MIME-Version: 1.0
Content-ID: <9634.1531912639.1@warthog.procyon.org.uk>
Date: Wed, 18 Jul 2018 12:17:19 +0100
Message-ID: <9635.1531912639@warthog.procyon.org.uk>
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
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

David Howells <dhowells@redhat.com> wrote:

> A better way might be to add a global waitqueue and then use that to watch for
> an indication that a key is about to be finally destroyed.  A flag can be set
> on the key to ask for the waitqueue to be poked

Hmmm...  This wouldn't work unless you added yourself to the waitqueue before
decrementing the key usage count:-/

In fact, if someone creates a link to your key, sync'ing the gc isn't
sufficient.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
