Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5D4B210F30AE
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 21:58:50 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 04/11] nfit/libnvdimm: add unlock of nvdimm support for
 Intel DIMMs
Date: Tue, 3 Jul 2018 04:58:45 +0000
Message-ID: <AT5PR8401MB11698726FDD969FF8D75B9EEAB420@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
 <153057476931.38125.15448927598576316449.stgit@djiang5-desk3.ch.intel.com>
 <AT5PR8401MB1169BD7B3DE8CDA8BA5AE658AB420@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4ipAULUgtV6rvx7hQBLtjr7VSE25KvBiHxHRe7TT0HvKA@mail.gmail.com>
In-Reply-To: <CAPcyv4ipAULUgtV6rvx7hQBLtjr7VSE25KvBiHxHRe7TT0HvKA@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Schofield, Alison" <alison.schofield@intel.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dhowells@redhat.com" <dhowells@redhat.com>, "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>


> > Since it contains a high-value password, I recommend zeroing
> > cmd->passphrase before calling kfree() so that data isn't seen
> > by a subsequent kmalloc() caller (and make sure the compiler
> > cannot optimize away the clearing code).
> >
> > Also, check if the ndctl() call chain makes any copies of cmd-
> > passphrase and ensure they are cleared.
> 
> If an attacker can run arbitrary code in the kernel they can get the
> key from the ring directly, or turn on ACPI debug. A platform could
> arrange for the DIMMs to be unlocked pre-OS to minimize passphrase
> exposure, but once you need to unlock from the OS at runtime there is
> this exposure. Now, there may be ways we could protect the key the
> TPM
> to minimize exposure, but there would always be the in-flight risk,
> especially with ACPI debug.

TCG Opal poses the same problems, discussed before in this thread:
http://lists.infradead.org/pipermail/linux-nvme/2016-May/004646.html

Ultimately we might need to rely on code running in encrypted memory
(e.g., SGX) to unpack the password from TPM-based storage, wrap it with
a temporary session key (e.g., based on TCG PSK secure sessions, or
public/private keys), and only pass that non-reusable bundle through
the kernel. That'll require more complex devices, though.





_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
