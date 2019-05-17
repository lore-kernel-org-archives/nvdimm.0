Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com
 [IPv6:2a00:1450:4864:20::542])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B461A21237AA0
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 10:41:54 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id a8so11701113edx.3
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 10:41:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190516224053.3655-1-vishal.l.verma@intel.com>
 <CA+CK2bCEUjCNGHcfqh+4gxtf80eUkz_swNny6A2mkJwLi6Yn+Q@mail.gmail.com>
 <ff36c9ecc9073ea39b0a501d8abf5cfc48db388f.camel@intel.com>
In-Reply-To: <ff36c9ecc9073ea39b0a501d8abf5cfc48db388f.camel@intel.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 17 May 2019 13:41:42 -0400
Message-ID: <CA+CK2bCtZGAjQa9OAckgoecz31xN_1iYFkUjzmLhshSa80bSFA@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 00/10] daxctl: add a new reconfigure-device
 command
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> Hi Pavel,
>
> I've still not been able to hit this in my testing, is it something you
> hit only after applying these patches? i.e. does plain v65 work?

Yes, plain v65 works, but with these patches I see this error.

I use buildroot to build initramfs with ndctl. Here is how ndctl.mk looks like:

NDCTL_VERSION = ed17fd1
NDCTL_SITE = $(call github,pmem,ndctl,$(NDCTL_VERSION))
NDCTL_LICENSE = GNU Lesser General Public License v2.1
NDCTL_LICENSE_FILES = COPYING

#NDCTL_AUTORECv65ONF = YES
define NDCTL_RUN_AUTOGEN
        cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
endef
NDCTL_PRE_CONFIGURE_HOOKS += NDCTL_RUN_AUTOGEN
NDCTL_LDFLAGS = $(TARGET_LDFLAGS)
NDCTL_CONF_OPTS = \
        --without-bash \
        --without-keyutils \
        --without-systemd

$(eval $(autotools-package))

This version works,  but when I change:
NDCTL_VERSION = 9ee82c8

I get add_dev error.

Pasha
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
