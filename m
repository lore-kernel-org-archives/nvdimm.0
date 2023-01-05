Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E46367
	for <nvdimm@lists.linux.dev>; Thu,  5 Jan 2023 00:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7572EC433B0;
	Thu,  5 Jan 2023 00:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672879095;
	bh=+L9zhcB+hUYsHjcRcqemJqoGzF3x7d5CEb6FU4DWqac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WL687Kncqgklk45rSEUmRACcroNljnbgdpcKFptf5DqAPBW78Z/NNWYc82CjT/bfO
	 93+pVhh35Tpt42P19/AQy5ZApRuyxi/sI3TyhwCvvbun9E6KuGt5yaCmeNtCGroKoi
	 8uasysST/D8M9m3fpl6tLCsIFIW55apBrWDSzGi5lpOXne0QRbUlkKea1xSnMgZ9zo
	 LWQkR2MYB7IkIm+9bKOsPE6jO6HAXsmMp2wTx5jxvtaz4cqquAGRVIBNVuyv7BxA4M
	 5lQWjMkYF0uwYjaMRGpdjKo/oS2Ly/ox3gef7rEinayWupH6pkvCPGv3MO0B1isom5
	 Uskow1uXCa+zQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id C96D55C1C77; Wed,  4 Jan 2023 16:38:14 -0800 (PST)
From: "Paul E. McKenney" <paulmck@kernel.org>
To: rcu@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	rostedt@goodmis.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	nvdimm@lists.linux.dev
Subject: [PATCH rcu 11/27] drivers/dax: Remove "select SRCU"
Date: Wed,  4 Jan 2023 16:37:57 -0800
Message-Id: <20230105003813.1770367-11-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
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

