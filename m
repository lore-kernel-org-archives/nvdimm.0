Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CBE0E2097DD37
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 13:38:58 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <a3bce7ee-96b0-bafc-3194-52b4fcc08f84@intel.com>
References: <a3bce7ee-96b0-bafc-3194-52b4fcc08f84@intel.com>
 <153186085546.27463.5501870662513432986.stgit@djiang5-desk3.ch.intel.com>
 <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
 <7121.1531911057@warthog.procyon.org.uk>
Subject: Re: [PATCH v5 02/12] libnvdimm: create keyring to store security keys
MIME-Version: 1.0
Content-ID: <17485.1531946334.1@warthog.procyon.org.uk>
Date: Wed, 18 Jul 2018 21:38:54 +0100
Message-ID: <17486.1531946334@warthog.procyon.org.uk>
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

Dave Jiang <dave.jiang@intel.com> wrote:

> > I wonder if you could just use &init_cred instead.
> 
> You mean also instead of a dedicated keyring, just use the existing ones
> that comes with init_cred as well?

You don't need a cred to use your own keyring that I can see.  If you look at
nvdimm_search_key(), you're not actually using the cred, but just taking the
keyring out of it:

	keyref = keyring_search(make_key_ref(nvdimm_cred->thread_keyring, 1),
			&nvdimm_key_type, nvdimm->dimm_id);

Further, when you call request_key(), you want to look in the user's keyrings,
I presume, so you can't actually override current->cred with nvdimm_cred.

As far as I can see, you don't use nvdimm_cred, except as somewhere to stash
the keyring pointer.  You could just skip the creds and store the keyring
pointer directly.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
