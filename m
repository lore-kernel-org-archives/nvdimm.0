Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com
 [IPv6:2607:f8b0:4864:20::732])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8CD61211575F2
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 18:12:49 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id o89so19821114qko.0
 for <linux-nvdimm@lists.01.org>; Tue, 06 Nov 2018 18:12:49 -0800 (PST)
Received: from gabell ([2601:18f:600:d880:c1f1:36c5:d40:1949])
 by smtp.gmail.com with ESMTPSA id b8sm27174008qka.79.2018.11.06.18.12.47
 for <linux-nvdimm@lists.01.org>
 (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
 Tue, 06 Nov 2018 18:12:47 -0800 (PST)
Date: Tue, 6 Nov 2018 21:12:46 -0500
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Question about unit test for acpi_nfit_notify().
Message-ID: <20181107021245.amegu3dwawlwyxob@gabell>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Let me ask a question about unit test for acpi_nfit_notify().

The unit test was introduced by commit c14a868a5a14 ("tools/testing/nvdimm:
unit test for acpi_nfit_notify()"), however, it seems that it doesn't
work currently. When I road the nfit_test.ko, I got the following
message.

  nfit_test nfit_test.0: failed to evaluate _FIT

That is because the 2nd argument of __acpi_nfit_notify(), nfit_test,
isn't allocated as nfit_test_resource structure, so
__wrap_acpi_evaluate_object() doesn't do anything, just call
acpi_evaluate_object(). The nfit_test is passed to acpi_evaluate_object()
as the 1st argument, handle. The nfit_test isn't useful for the
handle, so I got the error message.

nfit_test->_fit is allocated as nfit_test_resource structure,
so I thought it is fixed by the change look like as following.

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index cffc2c5a778d..3bae4a879f5f 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -2670,7 +2670,7 @@ static int nfit_test_probe(struct platform_device *pdev)
        obj->buffer.length = nfit_test->nfit_size;
        obj->buffer.pointer = nfit_test->nfit_buf;
        *(nfit_test->_fit) = obj;
-       __acpi_nfit_notify(&pdev->dev, nfit_test, 0x80);
+       __acpi_nfit_notify(&pdev->dev, nfit_test->_fit, 0x80);

        /* associate dimm devices with nfit_mem data for notification testing */
        mutex_lock(&acpi_desc->init_mutex);

However, if so, obj, which is allocated before calling __acpi_nfit_notify(),
gets meaningless...

I would like to fix this issue but I'm confusing now... Am I missing
something? I would applicate if someone could help.

Thanks!
Masa
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
