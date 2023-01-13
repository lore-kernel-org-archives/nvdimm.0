Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F90364
	for <nvdimm@lists.linux.dev>; Fri, 13 Jan 2023 00:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20B1C433AE;
	Fri, 13 Jan 2023 00:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673568695;
	bh=zptD60J3Cgt8c0EJaqWm6Hr2VBVz43WogJYOiD1uaCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NeLRKlF0bGaJujtGzLQoo5wOqPOWMj2ogv6jHaUpUKDczJJtA0Fs51mBlLovS1yf3
	 o7g538PWMJeFU4s/+DJdMZrRGWmhIAWkMDhki0eX+MGoJEBVGeIeXSfoBwSY8vmWyO
	 5UbEMMANXT6cZJ5HvAIbIOOh5XCTy5FWWarkaVJCMGzhNe7qXAQMiEmlFKfN1e0ehQ
	 aDcVBF6PVIt6c7l+k81P1IKTnbl5yojYnK/xkRzT0gnH6blVw1LmYnP90c43VmmNEZ
	 ejdVQ949m1uHjn2ueTMVa6eFuBOky7bNK06wLDFH2cYbM5mcaUyzpP8VhpzCXsLPAY
	 /QESHRjpYfxig==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 9CB625C10CA; Thu, 12 Jan 2023 16:11:34 -0800 (PST)
From: "Paul E. McKenney" <paulmck@kernel.org>
To: rcu@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	rostedt@goodmis.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	nvdimm@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>
Subject: [PATCH rcu v2 04/20] drivers/dax: Remove "select SRCU"
Date: Thu, 12 Jan 2023 16:11:16 -0800
Message-Id: <20230113001132.3375334-4-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20230113001103.GA3374173@paulmck-ThinkPad-P17-Gen-1>
References: <20230113001103.GA3374173@paulmck-ThinkPad-P17-Gen-1>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the SRCU Kconfig option is unconditionally selected, there is
no longer any point in selecting it.  Therefore, remove the "select SRCU"
Kconfig statements.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: <nvdimm@lists.linux.dev>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
---
 drivers/dax/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index 5fdf269a822e5..2bf5123e48279 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menuconfig DAX
 	tristate "DAX: direct access to differentiated memory"
-	select SRCU
 	default m if NVDIMM_DAX
 
 if DAX
-- 
2.31.1.189.g2e36527f23

