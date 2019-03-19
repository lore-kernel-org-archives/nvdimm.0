From: James Bottomley <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [PATCH] security/keys/trusted: Allow operation without hardware
 TPM
Date: Mon, 18 Mar 2019 17:56:29 -0700
Message-ID: <1552956989.2785.31.camel@linux.ibm.com>
References: <155295271345.1945351.6465460744078693578.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1552955080.2785.26.camel@linux.ibm.com>
 <CAA9_cmcOD2zPaaNbkYAaH5DRDRAebPkW+hwPA0zPKY4kU8R-rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAA9_cmcOD2zPaaNbkYAaH5DRDRAebPkW+hwPA0zPKY4kU8R-rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Mon, 2019-03-18 at 17:30 -0700, Dan Williams wrote:
> On Mon, Mar 18, 2019 at 5:24 PM James Bottomley <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
> wrote:
> > 
> > On Mon, 2019-03-18 at 16:45 -0700, Dan Williams wrote:
> > > Rather than fail initialization of the trusted.ko module, arrange
> > > for the module to load, but rely on trusted_instantiate() to fail
> > > trusted-key operations.
> > 
> > What actual problem is this fixing?  To me it would seem like an
> > enhancement to make the trusted module fail at load time if there's
> > no TPM rather than waiting until first use to find out it can never
> > work. Is there some piece of user code that depends on the
> > successful insertion of trusted.ko?
> 
> The module dependency chain relies on it. If that can be broken that
> would also be an acceptable fix.
> 
> I found this through the following dependency chain: libnvdimm.ko ->
> encrypted_keys.ko -> trusted.ko.
> 
> "key_type_trusted" is the symbol that encrypted_keys needs regardless
> of whether the tpm is present.

That's a nasty dependency caused by every key type module exporting a
symbol for its key type.  It really seems that key types should be
looked up by name not symbol to prevent more of these dependency issues
from spreading.  Something like this (untested and definitely won't
work without doing an EXPORT_SYMBOL on key_type_lookup).

If it does look acceptable we can also disentangle the nasty module
dependencies in the encrypted key code around masterkey which alone
should be a huge improvement because that code is too hacky to live.

James

---
diff --git a/security/keys/encrypted-keys/masterkey_trusted.c b/security/keys/encrypted-keys/masterkey_trusted.c
index dc3d18cae642..b98416f091e2 100644
--- a/security/keys/encrypted-keys/masterkey_trusted.c
+++ b/security/keys/encrypted-keys/masterkey_trusted.c
@@ -19,6 +19,7 @@
 #include <keys/trusted-type.h>
 #include <keys/encrypted-type.h>
 #include "encrypted.h"
+#include "../internal.h"
 
 /*
  * request_trusted_key - request the trusted key
@@ -32,8 +33,14 @@ struct key *request_trusted_key(const char *trusted_desc,
 {
 	struct trusted_key_payload *tpayload;
 	struct key *tkey;
+	struct key_type *type;
 
-	tkey = request_key(&key_type_trusted, trusted_desc, NULL);
+	type = key_type_lookup("trusted");
+	if (IS_ERR(type)) {
+		tkey = (struct key *)type;
+		goto error;
+	}
+	tkey = request_key(type, trusted_desc, NULL);
 	if (IS_ERR(tkey))
 		goto error;
