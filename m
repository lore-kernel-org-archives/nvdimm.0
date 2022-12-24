Received: from r3-22.sinamail.sina.com.cn (r3-22.sinamail.sina.com.cn [202.108.3.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8846617C9
	for <nvdimm@lists.linux.dev>; Sat, 24 Dec 2022 02:15:07 +0000 (UTC)
Received: from unknown (HELO localhost.localdomain)([114.249.57.238])
	by sina.com (172.16.97.32) with ESMTP
	id 63A65FBD0003766D; Sat, 24 Dec 2022 10:11:11 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 594027629145
From: Hillf Danton <hdanton@sina.com>
To: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Cc: linux-rdma@vger.kernel.org,
	leonro@nvidia.com,
	jgg@nvidia.com,
	zyjzyj2000@gmail.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	rpearsonhpe@gmail.com,
	yangx.jy@fujitsu.com,
	lizhijian@fujitsu.com,
	y-goto@fujitsu.com
Subject: Re: [PATCH for-next v3 1/7] RDMA/rxe: Convert triple tasklets to use workqueue
Date: Sat, 24 Dec 2022 10:14:17 +0800
Message-Id: <20221224021417.2219-1-hdanton@sina.com>
In-Reply-To: <d2f6b3aca61fe1858a97cda94691eece6b0e60bd.1671772917.git.matsuda-daisuke@fujitsu.com>
References: <cover.1671772917.git.matsuda-daisuke@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 23 Dec 2022 15:51:52 +0900 Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
> @@ -137,15 +153,27 @@ void rxe_sched_task(struct rxe_task *task)
>  	if (task->destroyed)
>  		return;
>  
> -	tasklet_schedule(&task->tasklet);
> +	/*
> +	 * busy-loop while qp reset is in progress.
> +	 * This may be called from softirq context and thus cannot sleep.
> +	 */
> +	while (atomic_read(&task->suspended))
> +		cpu_relax();
> +
> +	queue_work(task->workq, &task->work);
>  }

This busy wait particularly in softirq barely makes sense given the
flush_workqueue() below.
>  
>  void rxe_disable_task(struct rxe_task *task)
>  {
> -	tasklet_disable(&task->tasklet);
> +	/* Alternative to tasklet_disable() */
> +	atomic_inc(&task->suspended);
> +	smp_mb__after_atomic();
> +	flush_workqueue(task->workq);
>  }
>  
>  void rxe_enable_task(struct rxe_task *task)
>  {
> -	tasklet_enable(&task->tasklet);
> +	/* Alternative to tasklet_enable() */
> +	smp_mb__before_atomic();
> +	atomic_dec(&task->suspended);
>  }

Feel free to add one-line comment for why smp_mb is needed in both
cases.
